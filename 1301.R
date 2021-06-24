# 1301
# 2019-14505 엄세희

library(tidyverse)
df_mass = starwars %>% select(gender, mass)
t.test(mass ~ gender, data = df_mass, var.equal = 1) # original t검정, -0.82841
t.test(mass ~ gender, data = df_mass, var.equal = 0) # welch's t검정, -1.936

# welch's t검정의 경우, 두 집단의 분산이 다를 것이라고 전제하고 분석한 값이다.
# 따라서 두 집단의 분산을 모르는 상태에서는 더 정확한 값이 나오리라 기대할 수 있다.
# t값의 절대값이 더 크게 나왔으므로 더 극단적인 결과가 나왔다고 볼 수 있다.
# 대립가설의 더 좋은 근거가 될 수 있다.

# confidence interval밑에 나오는 두 값은 신뢰구간의 양 끝 값으로,
# 전체 데이터 중 95%의 표본이 들어갈 특정한 구간을 나타내는 값이다.

