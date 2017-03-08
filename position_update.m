function position = position_update(position,velocity,time_step_size)
  % This function updates the position for n units given the existing
  % position and the velocity for each unit (in vector form).
  
  % Decompose the velocity for each unit into x and y components
  x_velocity = cos(velocity(2,:)).*velocity(1,:);
  y_velocity = sin(velocity(2,:)).*velocity(1,:);
  
  % Update the position for each unit
  position = position + [x_velocity;y_velocity].*(time_step_size);
end