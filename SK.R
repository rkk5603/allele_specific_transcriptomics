# ------------------ 3.5 Conduct Statistical Tests ---------------------------------------------------------
# --------- 3.5.1 SNP-level Storer-Kim (SK) binomial exact tests

# For each SNP, a Storer-Kim binomial exact test of two proportions is conducted using the MRN counts
# to test the hypothesis that the proportion of maternal and paternal read counts are statistically different 
twobinom<-function(r1,n1,r2,n2,alpha=.05){
  # r1 = success in group 1
  # n1 = total in group 1
  # r2 = success in group 2
  # r2 = total in group 2
  n1p<-n1+1
  n2p<-n2+1
  n1m<-n1-1
  n2m<-n2-1
  q <- r1/n1
  p <- r2/n2
  if(is.na(q)){q <- 0}
  if(is.na(p)){p <- 0}
  chk<-abs(q-p)
  x<-c(0:n1)/n1
  y<-c(0:n2)/n2  
  phat<-(r1+r2)/(n1+n2)
  m1<-t(Outer(x,y,"-"))
  m2<-matrix(1,n1p,n2p)
  flag<-(abs(m1)>=chk)
  m3<-m2*flag
  rm(m1,m2,flag)
  xv<-c(1:n1)
  yv<-c(1:n2)
  xv1<-n1-xv+1
  yv1<-n2-yv+1
  dis1<-c(1,pbeta(phat,xv,xv1))
  dis2<-c(1,pbeta(phat,yv,yv1))
  pd1<-NA
  pd2<-NA
  for(i in 1:n1){pd1[i]<-dis1[i]-dis1[i+1]}
  for(i in 1:n2){pd2[i]<-dis2[i]-dis2[i+1]}
  pd1[n1p]<-phat^n1
  pd2[n2p]<-phat^n2
  m4<-t(Outer(pd1,pd2,"*"))
  test<-sum(m3*m4)
  rm(m3,m4)
  list(p.value=test,p1=q,p2=p,est.dif=q-p)
}

# wrapper function to perform the Storer-Kim test
AST.SK <- function(counts,phenotype,cores){
  # counts = phenotype-specific counts matrix
  # phenotype = corresponding phenotype of counts
  # cores = # of threads for multithreaded search
  
  # Split data by pat and mat
  pat.exp <- counts[,metadata[metadata$parent%in%c("M")&
                                metadata$phenotype==phenotype,"sample.id"]]
  mat.exp <- counts[,metadata[metadata$parent%in%c("F")&
                                metadata$phenotype==phenotype,"sample.id"]]
  # Set up for DoParallel
  SKrows=counts$SKrow
  registerDoParallel(cores=cores)
  i.len=length(row.names(pat.exp))
  
  # For each row, conduct an SK test and return the p-value
  return.df <- foreach(i=1:i.len, .combine=rbind,
                       .export=ls(globalenv()),.packages="Rfast") %dopar% {
                         SNP_gene=row.names(pat.exp[i,])
                         p1.s=sum(pat.exp[i,])
                         p2.s=sum(mat.exp[i,])
                         p.o=sum(p1.s,p2.s)
                         if(SKrows[i]==T){
                           test=twobinom(r1=p1.s,n1=p.o,
                                         r2=p2.s,n2=p.o)$p.value
                         }else{
                           test=fisher.test(matrix(c(p1.s,p2.s,
                                                     p2.s,p1.s),ncol = 2))$p.value
                         }
                         return.append=data.frame(SNP_gene=SNP_gene,p=test)
                         return(return.append)
                       }
  return.df=return.df[match(row.names(pat.exp), return.df$SNP_gene),]
  
  # Return
  return(return.df)
}

# Execute
GN.SK <- AST.SK(GN_counts_normalized,"GN",6)
BN.SK <- AST.SK(BN_counts_normalized,"BN",6)

# Save output
write.csv(GN.SK,"~/scratch/AST/ANALYSIS/RESULTS/Block1_GN_SK.csv", row.names=F)
write.csv(BN.SK,"~/scratch/AST/ANALYSIS/RESULTS/Block1_BN_SK.csv", row.names=F)
