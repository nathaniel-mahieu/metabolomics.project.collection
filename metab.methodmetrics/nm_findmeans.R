nm_findmeans = function(data) {
  ddply(data, "method", function(x) { 
    data.frame(
      egauss=mean(x$egauss, na.rm=T),
      sn=mean(x$sn[!is.na(x$sn) & is.finite(x$sn)], na.rm=T),
      log.sn = mean(log10(x$sn[!is.na(x$sn) & is.finite(x$sn)]), na.rm=T),
      tailing=mean(x$tailing, na.rm=T),
      log.tailing = mean(log10(x$tailing[!is.na(x$tailing) & is.finite(x$tailing)]), na.rm=T),
      maxo=mean(x$maxo, na.rm=T),
      log.maxo = mean(log10(x$maxo), na.rm=T)
    )
  })
}