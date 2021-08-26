library(tidyverse)
df <- haven::read_sav("data/CSM Studie T1_August 25, 2021_16.36.sav")
names(df)

scalenames_csm <- c("cimp", "cbui", "cuse","chum", "cgoa","cslf", "cmob", "neg", "fee", "mon", "eng")
scalenames_correlates <- c("ca", "crastr", "crasoc", "cracha", "ceng", "pcb", "pi", "ose", "neo", "hapa", "hh", "lgo", "bco", "jti", "plnfl", "grwth")

l_scales_csm <- map(scalenames_csm, function(scale) df %>% select(starts_with(scale)))
names(l_scales_csm) <- scalenames_csm
l_scales_correlates <- map(scalenames_correlates, function(scale) df %>% select(starts_with(scale)))
names(l_scales_correlates) <- scalenames_correlates

# attc <- df %>% select(starts_with("attc")) %>% rowSums()

# testing timer sums
df_timer <- df %>% select(starts_with("timer")) %>% map_dfc(., as.numeric)
with(df_timer[c(5,6),], timerG1+timerG2+timerG3+timerG4+timerG5 - timertotal) # should be 0.

# add all items
df_items <- map_dfc(c(l_scales_csm, l_scales_correlates), function(x) x)
ncol(df_items)*2 # minimum timertotal for good quality.


# T2
df_t2 <- haven::read_sav("data/CSM Studie T2_August 26, 2021_15.24.sav")

names(df_t2)
scalenames_correlates_t2 <- c("lmx", "supw", "supc", "weng", "jcha", "oexp", "pjf", "scs", "mvi", "mve", "vi", "cgco", "cgcl","jmk")

l_scales_csm_t2 <- map(scalenames_csm, function(scale) df_t2 %>% select(starts_with(scale)))
names(l_scales_csm_t2) <- scalenames_csm
l_scales_correlates_t2 <- map(scalenames_correlates_t2, function(scale) df_t2 %>% select(starts_with(scale)))
names(l_scales_correlates_t2) <- scalenames_correlates_t2

df_items_t2 <- map_dfc(c(l_scales_csm_t2, l_scales_correlates_t2), function(x) x)

df_timer_t2 <- df_t2 %>% select(starts_with("timer")) %>% map_dfc(., as.numeric)
embedded_time <- with(df_timer_t2[c(1,2,3),], timerG1+timerG2+timerG3)[1] # should be 0.
all_timers <- df_t2 %>% select(contains("Page_Submit")) %>% rowSums()
all_timers - embedded_time # should be 0 (rounding errors may apply)
all_timers - as.numeric(df_t2$timertotal) # shoul be 0 (for later entries where timertoal is correctly calc.)
