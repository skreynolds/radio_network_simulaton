function distance = calculate_distance(origin,position)
  % This function will calculate travelled since the unit
  % position was last updated.
  distance = ((position(1,:)-origin(1,:)).^2+...
                  (position(2,:)-origin(2,:)).^2).^0.5;
end