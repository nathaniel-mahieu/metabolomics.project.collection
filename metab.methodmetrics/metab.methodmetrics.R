# Things we should asses for method performance:

# Sensitivity
# - s/n
# - absolute height

# Symmetry
# - Tailing Factor

# Retention
# - RT

# Peak width
# - fwhm

# Background Signal
# - Total signal not in peaks
# - Total signal not in credentialed features

# Relative Adduction
# - INa/IH



# Fragmentation
# - 

# Oxidation
# - levels of glutathione

#Resolution
# - glucose 6-P vs F 6-P

# Hydrolysis
# - ATP, ADP, AMP levels

get_methodstats = function(xs, xr, cfs) {
  # Background
  cps = xs@peaks[cfs[,"peaknum_a"],]
  signal_cf = sum(cps[,"intb"],na.rm=T)
  signal_allpeak = sum(xs@peaks[,"intb"],na.rm=T)
  signal_total = sum(xr@tic)
  signal_cf/signal_allpeak
  signal_allpeak/signal_total
  
  methodstats = cbind(
    signal_total = signal_total,
    signal_allpeak = signal_allpeak,
    signal_cf = signal_cf,
    peaks_total = nrow(xs@peaks),
    cps_total = nrow(cps)
    )

}

get_adductstats = function(an, rule1, rule2) {

  all_masses = do.call("rbind", lapply(1:length(an@pspectra), function(x) {
    neutral_masses = do.call("rbind", lapply(an@pspectra[[x]], function(y) {
      do.call("rbind", lapply(an@derivativeIons[[y]], function(z) {
        cbind(neutral = z$mass, rule = z$rule_id, peaknum=y, psg = x)
      }))
    }))
  }))
  
  
  add_add_pairs = do.call("rbind",lapply(which(all_masses[,"rule"] == rule1), function(x) {
    mh = all_masses[x,,drop=F]
    a_pair = all_masses[
      all_masses[,"psg"] == mh[,"psg"] &
        withinppm(all_masses[,"neutral"], mh[,"neutral"]) &
        all_masses[,"rule"] == rule2,
      
      ,drop=F]
    
    if(nrow(a_pair) < 1) {return(NULL)}
    
    cbind(neutral=mh[,"neutral"],psg = mh[,"psg"], mh_peaknum = mh[,"peaknum"], mcl_peaknum = a_pair[,"peaknum"])
    
  }))
}

get_peakstats = function(xs, xr) {

  eics = lapply(1:nrow(xs@peaks), function(i) {
    peak = xs@peaks[i,,drop=F]
    
    nm_eic(xr, peak[,"mz"], peak[,"rt"], peak[,"rtmin"], peak[,"rtmax"], 20, 100)
  })
  
  #Peak FWHM
  peakwidths = xs@peaks[,"rtmax"] - xs@peaks[,"rtmin"]
  peakfwhms =  sapply(1:nrow(xs@peaks), function(i) {
    peak = xs@peaks[i,,drop=F]
    
    calc_fwhm(eics[[i]], peak[,"rtmin"], peak[,"rtmax"])
  })
  #hist(peakfwhms, breaks=c(seq(0,90,.5),1E9), xlim=c(0,90))
  
  # Tailing
  tailing_factors = sapply(eics, calc_tailing_factor)
  #hist(tailing_factors, breaks=c(seq(0,10,.5),1E9), xlim=c(0,10))
  
  # Noise
  noise = lapply(1:nrow(xs@peaks),function(i) {
    peak = xs@peaks[i,,drop=F]
      
    est_chrom_noise(eics[[i]], peak[,"rtmin"], peak[,"rtmax"])
   })
  avg_noise = sapply(noise, mean)
  
  # S/N
  sn = xs@peaks[,"maxo"]/avg_noise
  
  peak_stats = cbind(
    peakfwhm = peakfwhms, 
    sn = sn,
    noise = avg_noise,
    tailing = tailing_factors
    )
}

est_chrom_noise = function(eic, rtmin, rtmax) {
  
  start = which.min(abs(eic[,"scan"] - rtmin))
  end = which.min(abs(eic[,"scan"] - rtmax))
  
  if (start-20 < 1) {pre_noise = 1}
  else  { pre_noise = mean(eic[(start-20):(start-10), "intensity"]) }
  
  if (end+20 > nrow(eic)) {post_noise = 1}
  else  { post_noise = mean(eic[(end+20):(end+10), "intensity"]) }

  c(pre_noise, post_noise)
}


calc_tailing_factor = function(eic) {
  # eic = matrix(scan, intensity)
  # http://www.chromatographytoday.com/news/autosamplers-detectors-pumps-valves-data-handling/36/breaking_news/what_is_peak_tailing/31253/
  
  maxint = max(eic[,"intensity"])
  ordered_mins = order(abs(eic[,"intensity"] - maxint * .3))
  
  tip = which.min(abs(eic[,"intensity"] - maxint))
  leading70 = ordered_mins[which(ordered_mins < tip)][1]
  trailing70 = ordered_mins[which(ordered_mins > tip)][1]
  
  ts = (trailing70-tip) / (tip - leading70)
  ts
}

calc_fwhm = function(eic, rtmin, rtmax) {
  maxint = max(eic[,"intensity"])
  ordered_mins = order(abs(eic[,"intensity"] - maxint * .5))
  
  tip = which.min(abs(eic[,"intensity"] - maxint))
  leading50 = ordered_mins[which(ordered_mins < tip)][1]
  trailing50 = ordered_mins[which(ordered_mins > tip)][1]
  fwhm = trailing50 - leading50
}