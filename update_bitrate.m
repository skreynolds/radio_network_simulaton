function bitrate = update_bitrate(data_sent)
  % This function calculates the bitrate averaged over each second
  bitrate = sum(data_sent);
end