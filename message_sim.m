% Clear the workspace and all variables
clear; clc;
% Load the communications package
% pkg load communications %not required in MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Parameters for the simulation %%%%%%%%%%%%%%%%%%%%%%%
n = 30; %number of soldiers equiped in AROS
max_velocity = 5.5; %max velocity in m/s
disc_states = 256; %number of states velocity will be discretised
time_step_size = 1; %this is in seconds
time_steps = 180/time_step_size; %set the number of time steps in the simulation
message_size = 88; %set the size of the message that will be sent
mu = 1.92; %average velocity for infantry
sigma = 1.85; %standard deviation for infantry
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialise the velocities and their probability distributions
% for the troop velocities
desc_vel = linspace(0,max_velocity,disc_states); %discrete velocities
p_vel = velocity_profile(mu,sigma,disc_states); %create velocity and probabilities

% Initialise position, origin, and velocity array for soldiers
% The position array is a 2xn array. The first row hold x-coordinates
% for each of the n soldiers, and the second row holds y-coordinates 
position = zeros(2,n);

% The velocity array is 2xn array. The first row holds speed, and 
% the second row holds the direction in radians clockwise from North
velocity = update_velocity(n,desc_vel,p_vel);

% The origin is initialised at the point at which the soldier starts
% and then updated each time a message is sent.
origin = position;

% Initialise time elapsed since the 10m distance trigger has
% been tripped.
elapsed_time = zeros(1,n);

% Initialise the data sent vector - a vector which holds a record
% of the amount of data sent during a 1 second interval
data_sent = zeros(1,n);

% Initialise simulation window
figure(1); %set up window for figure to display simulation

% Build circle
k = linspace(0,2*pi,100); %parametric variable for drawing circle
circle_x = 10*cos(k);
circle_y = 10*sin(k);

% Draw each of the simulation windows for each of the units
for i = 1:n
  subplot(5,6,i);
  plot(circle_x,circle_y);
  axis([-256 256 -256 256], 'square');
  hold on;
  plot(position(1,i),position(2,i),'r.');
  hold off;
end
drawnow

% Initialise other simulation parameters
time = 0; %set the time clock to zeros (this is timestep units)
bit_rate = 0; %the initial bit rate for the simulation is zero.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t = 1:time_steps
  % Update the time
  time = t*time_step_size; %note that time is seconds
  
  % Update the position and velocity for each of the troops
  if mod(time*time_step_size,2) == 0 %updates velocity every 2 seconds
    velocity = update_velocity(n,desc_vel,p_vel); %updated velocity
  end
  position = position_update(position,velocity,time_step_size); %updated position
  
  % Return a logic vector showing if data is being sent
  [data_sent_logic_vec,elapsed_time] = ...
            data_send_query(origin,position,elapsed_time,time_step_size);
  
  % Update the data sent over a 1 millisecond interval
  data_sent = data_sent + message_size.*data_sent_logic_vec;
  
  % Update the elapsed time vectorize
  elapsed_time = (~data_sent_logic_vec).*elapsed_time;
  
  % Update the origin if data has been sent
  origin(1,:) = origin(1,:) + ...
                    data_sent_logic_vec.*(position(1,:)-origin(1,:));
  origin(2,:) = origin(2,:) + ...
                    data_sent_logic_vec.*(position(2,:)-origin(2,:));
  
  % Update the bitrate - performed once per second.
  % Need to be able to adjust this for better resolution.
  % data_sent set to zero at 1 second time intervals.
  if mod(time*time_step_size,1) == 0
    bitrate(t) = update_bitrate(data_sent);
    data_sent = zeros(1,n);
    figure(2)
    plot(bitrate)
    title('Bitrate (bit/sec)');
    axis([0 time_steps 0 1000]);
    drawnow
  end
  
  % Redraw the simulation
  for i= 1:n
    figure(1)
    subplot(5,6,i);
    circle_x = 10*cos(k) + origin(1,i);
    circle_y = 10*sin(k) + origin(2,i);
    plot(circle_x,circle_y);
    axis([-256 256 -256 256], 'square');
    text = sprintf('Te: %d',elapsed_time(i));
    title(text);
    hold on;
    plot(position(1,i),position(2,i),'r.');
    hold off;
  end
  drawnow
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%