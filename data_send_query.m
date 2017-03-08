function [logic_vec,time_elapsed] = ...
            data_send_query(origin,position,time_elapsed,time_step_size)
  % This function queries if a unit needs to send a message or not
  
  % Check to see if the distance travelled from last message
  % is greater than 10m
  dist_cond = (calculate_distance(origin,position) > 10);
  
  % Update the amount of time elapsed since crossing the 10m threshold
  time_elapsed = time_elapsed + time_step_size.*dist_cond;
  
  % Check to see if the amount of time elapsed is greater than 36 seconds
  logic_vec = (time_elapsed > 30);
  
end