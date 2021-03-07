
-- MIT License
--
-- Copyright (c) 2019-2020 Nalquas
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

-- this info was taken from https://github.com/nesbox/TIC-80/wiki/TIC%20file%20format

local chunk_types = {
	[0x01] = "tiles",
	[0x02] = "sprites",
	[0x03] = "cover_image",
	[0x04] = "map",
	[0x05] = "code",
	[0x06] = "flags",
	[0x09] = "sfx",
	[0x0A] = "waveforms",
	[0x0C] = "palette",
	[0x0D] = "patterns_old",
	[0x0E] = "tracks",
	[0x0F] = "patterns",
	[0x10] = "code_zlib",
}
local function getstrchar(s, n)
	return s:sub(n, n)
end

local function parse_chunk(data, offset)
	local header_type = (getstrchar(data, offset)):byte()
	local chunk_type = header_type & 0x1F
	local chunk_bank = (header_type & 0xE0) >> 5
	local chunk_size = ( (getstrchar(data, offset+2)):byte() << 8) | (getstrchar(data, offset+1)):byte()
	local chunk_data = data:sub(offset+4, (offset+4+chunk_size)-1)
	
	return {
		type = chunk_types[chunk_type],
		bank = chunk_bank,
		data = chunk_data,
	}
end

local function parse(tic_data)
	local offset = 1
	local output = {}
	
	while offset < #tic_data do
		local parsed_chunk = parse_chunk(tic_data, offset)
		table.insert(output, parsed_chunk)
		offset = offset + #parsed_chunk.data+4
	end

	return output
end

return parse
