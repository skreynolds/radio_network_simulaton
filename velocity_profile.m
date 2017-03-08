function p_vel = velocity_profile(mu,sigma,disc_states)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Function will return a discrete probability distribution for troop %
  % velocities, roughly based on a log-normal distribution             %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % INPUT                                                              %
  % mu - the average velocity of the troops                            %
  % sigma - the standard deviation of the velocity                     %
  % OUTPUT                                                             %
  % p_vel - the output probability for each of the velocities          %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  data = lognrnd(mu,sigma,500);
  data = data(data<5.5);
  p_vel = hist(data,disc_states)/sum(hist(data,disc_states));
  try
    randsrc(1,1,[linspace(0,5.5,disc_states); p_vel]);
  catch ME
    p_vel = velocity_profile(mu,sigma,disc_states);
  end
end