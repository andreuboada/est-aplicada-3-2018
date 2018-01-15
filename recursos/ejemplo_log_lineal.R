data(HairEyeColor)
(HairEyeColor)
library(gRim)
library(gRbase)
library(Rgraphviz)

m_init <- dmod(~.^., data=HairEyeColor)

mod_hec <- gRim::stepwise(m_init, k = log(nrow(HairEyeColor)), 
                    direction='forward', type='unrestricted')
mod_hec
plot(mod_hec)
