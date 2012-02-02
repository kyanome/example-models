# http://www.mrc-bsu.cam.ac.uk/bugs/winbugs/Vol1.pdf
# Page 3: Rats
data {
  int(0,) N;
  int(0,) T;
  double x[T];
  double y[N,T];
}
transformed data {
  double xbar;
  double x_centered[T];

  xbar <- mean(x);
  for (t in 1:T) 
    x_centered[t] <- x[t] - xbar;
}
parameters {
  double alpha[N];
  double beta[N];

  double mu_alpha;
  double mu_beta;

  double(0,) sigmasq_y;
  double(0,) sigmasq_alpha;
  double(0,) sigmasq_beta;
}
transformed parameters {
  double(0,) sigma_y;
  double(0,) sigma_alpha;
  double(0,) sigma_beta;

  sigma_y <- sqrt(sigmasq_y);
  sigma_alpha <- sqrt(sigmasq_alpha);
  sigma_beta <- sqrt(sigmasq_beta);
}
model {
  mu_alpha ~ normal(0, 100);
  mu_beta ~ normal(0, 100);
  sigmasq_y ~ inv_gamma(0.001, 0.001);
  sigmasq_alpha ~ inv_gamma(0.001, 0.001);
  sigmasq_beta ~ inv_gamma(0.001, 0.001);
  alpha ~ normal(mu_alpha, sigma_alpha); // vectorized
  beta ~ normal(mu_beta, sigma_beta);  // vectorized
  for (n in 1:N)
    for (t in 1:T) 
      y[n,t] ~ normal(alpha[n] + beta[n] * (x[t] - xbar), sigma_y);

}
