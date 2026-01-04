def read_pgm_p5_no_lib(path):
    with open(path, 'rb') as f:
        tokens = []

        def next_token():
            nonlocal tokens
            while not tokens:
                line = f.readline()
                if not line:
                    raise EOFError("Unexpected EOF while reading header")
                line = line.strip()
                if not line:
                    continue
                if line.startswith(b'#'):
                    continue
                tokens.extend(line.split())
            return tokens.pop(0)

        # header: magic, width, height, maxval
        magic = next_token().decode('ascii')
        if magic != 'P5':
            raise ValueError(f"Not a P5 PGM file: magic={magic}")

        width = int(next_token())
        height = int(next_token())
        maxval = int(next_token())

        n = width * height

        if maxval <= 255:
            raw = f.read(n)
            if len(raw) < n:
                raise ValueError("Not enough pixel data for 8-bit P5")
            data_flat = list(raw)
        else:
            raw = f.read(2 * n)
            if len(raw) < 2 * n:
                raise ValueError("Not enough pixel data for 16-bit P5")
            data_flat = [(raw[i] << 8) + raw[i + 1]
                         for i in range(0, len(raw), 2)]

        data_2d = [data_flat[i*width:(i+1)*width]
                   for i in range(height)]

        return {
            'width': width,
            'height': height,
            'maxval': maxval,
            'data': data_2d,
            'magic': 'P5'
        }
