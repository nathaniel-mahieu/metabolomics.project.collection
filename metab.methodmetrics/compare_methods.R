if (F) {
  setwd("C:/Dropbox/GitHub/metab.methodmetrics/dev_data")
  library(devtools)
  load_all("../")
  
  xs_a = loadXs("2NM73A_QEc_nHILIC_04_2NM69F_9t10_0.5uL.mzXML.centWave.12.15.140.-0.0015.xcmsSet")
  an_a = loadAn("2NM73A_QEc_nHILIC_04_2NM69F_9t10_0.5uL.mzXML.11786.negative.0.1.0.75.FALSE.1000.xsAnnotate")
  xr_a = xcmsRaw(tail(strsplit(xs_a@filepaths,"/")[[1]], n=1))
  cfs_a = read.csv("../dev_data/credentialed_features_2NM73A04.csv")
  
  xs_b = loadXs("2NM73A_QEc_nHILIC_09_2NM69F_sheathT250_V11.mzXML.centWave.12.15.140.-0.0015.xcmsSet")
  an_b = loadAn("2NM73A_QEc_nHILIC_09_2NM69F_sheathT250_V11.mzXML.13464.negative.0.1.0.75.FALSE.1000.xsAnnotate")
  xr_b = xcmsRaw(tail(strsplit(xs_b@filepaths,"/")[[1]], n=1))
  cfs_b = read.csv("credentialed_features_2NM73A09.csv")
  
  peak_pairs = read.csv("alignment.csv")
  
  method_comparison = compare_methods(peak_pairs, xs_a, cfs_a, an_a, xr_a, xs_b, cfs_b, an_b, xr_b)

  theme_set(theme_minimal())
  theme_update(
    #legend.title=element_blank(),
    #panel.grid.major.x=element_blank(),
    #legend.position = c(.5, .95),
    #legend.direction = "horizontal"    
    #legend.position="top"
    legend.position = c(.95, .5)
  )
  theme_update(
    axis.text.y=element_blank(),
    axis.ticks.y = element_blank(),
    axis.line.y = element_blank(),
    axis.title.y=element_blank()
  )
  
  md = knit('C:\\Dropbox\\GitHub\\metab.methodmetrics\\R\\compare_methods.Rmd')
  html = markdownToHTML(md, "compare_methods.html")
  
  
  
  
  
  respairs_a = get_respairs(1:nrow(xs_a@peaks), xs_a, ppm=50, drt=60, dmaxo = 1)
  f = xs_a@peaks[respairs_a[380,],]
  a = xs_a@peaks[respairs_a[,1],]
  high = which(a[,"maxo"] > 1E4)
  f = xs_a@peaks[respairs_a[high[29],],]
  plot(nm_eic(xr_a, mean(f[,"mz"]), mean(f[,"rt"]), min(f[,"rtmin"]), max(f[,"rtmax"]), 100, 20), type="l")
  plot(nm_eic(xr_a, mean(f[1,"mz"]), mean(f[1,"rt"]), min(f[,"rtmin"]), max(f[,"rtmax"]), 20, 20), type="l")
  plot(nm_eic(xr_a, mean(f[2,"mz"]), mean(f[2,"rt"]), min(f[,"rtmin"]), max(f[,"rtmax"]), 20, 20), type="l")
  
}


get_respairs = function(peaknums, xs, ppm=50, drt=120, dmaxo = 1) {
  unique_cfs = unique(peaknums)
  
  do.call("rbind",lapply(1:(length(unique_cfs)-1), function(x) {
    peak = xs@peaks[unique_cfs[x],,drop=F]
    remain = xs@peaks[unique_cfs[(x+1):length(unique_cfs)],,drop=F]
    
    ppm = abs(peak[,"mz"] - remain[,"mz"])/peak[,"mz"] * 1E6 < ppm
    rt = abs(peak[,"rt"] - remain[,"rt"]) < drt
    maxo = abs(log10(peak[,"maxo"]) - log10(remain[,"maxo"])) < dmaxo
    
    yn = ppm & rt & maxo
    
    cbind(peaknum_1 = rep(unique_cfs[x], sum(yn)), peaknum_2 =unique_cfs[(x+1):length(unique_cfs)][yn])
    
    }))
}


compare_methods = function(peak_pairs, xs_a, cfs_a, an_a, xr_a, xs_b, cfs_b, an_b, xr_b) {
 
  methodstats_a = get_methodstats(xs_a, xr_a, cfs_a)
  peakstats_a = get_peakstats(xs_a, xr_a)
  h_cl_adductstats_a = get_adductstats(an_a, 1, 7)
  
  methodstats_b = get_methodstats(xs_b, xr_b, cfs_b)
  peakstats_b = get_peakstats(xs_b, xr_b)
  h_cl_adductstats_b = get_adductstats(an_b, 1, 7)
  
  pscf_a = peakstats_a[peak_pairs[,"peaknum_a"],]
  pscf_b = peakstats_b[peak_pairs[,"peaknum_b"],]
  
  peakstats = rbind.data.frame(
    data.frame(peakstats_a, method = rep("A", nrow(peakstats_a)), row = 1:nrow(peakstats_a), xs_a@peaks),
    data.frame(peakstats_b, method = rep("B", nrow(peakstats_b)), row = 1:nrow(peakstats_b), xs_b@peaks)
  )
  means = nm_findmeans(peakstats)
  
  pscf_a_ext = data.frame(pscf_a, method = rep("A", nrow(peak_pairs)), peaknum = peak_pairs[,"peaknum_a"], xs_a@peaks[peak_pairs[,"peaknum_a"],])
  pscf_b_ext = data.frame(pscf_b, method = rep("B", nrow(peak_pairs)), peaknum = peak_pairs[,"peaknum_b"], xs_b@peaks[peak_pairs[,"peaknum_b"],])
  cred_peakstats = rbind.data.frame(
    pscf_a_ext, 
    pscf_b_ext
  )
  cred_means = nm_findmeans(cred_peakstats)

  peakchanges = data.frame(pscf_b_ext/pscf_a_ext)
}


