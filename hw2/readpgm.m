function img = read_pgm(fname)

  fid = fopen(fname,'r');
  if fid==-1
    error("File not found");
  end

  % read magic number
  line = strtrim(fgetl(fid));
  if ~strcmp(line,"P5")
    error("Only binary PGM (P5) supported");
  end

  % skip comments
  line = strtrim(fgetl(fid));
  while line(1) == '#'
    line = strtrim(fgetl(fid));
  end

  dims = sscanf(line,"%d %d");
  width = dims(1);
  height = dims(2);

  maxval = fscanf(fid,"%d",1);
  fgetc(fid); % skip newline

  img = fread(fid,[width height],'uint8')';
  fclose(fid);

end
