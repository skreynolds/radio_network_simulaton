function velocity = update_velocity(n,desc_vel,p_vel)
  % This function will update the velocity vector for the number of
  % units specified, according to the discrete probability distribution
  % entered.
  velocity(1,:) = randsrc(1,n,[desc_vel; p_vel]);
  velocity(2,:) = pi*rand(1,n) - pi/2;
end