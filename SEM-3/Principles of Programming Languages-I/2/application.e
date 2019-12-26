note
	description: "heap_sort application root class"
	Author:"Akash Tadwai"
	date: "$18-11-19$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
make

feature
	len:INTEGER	--length of input array
	heap:MIN_HEAP --object representing min_heap class
	u_ar:ARRAY[INTEGER] --Given array
	s_ar:ARRAY[INTEGER]
	output : PLAIN_TEXT_FILE	--output file

	make   -- taking input from user and storing in arrays

		local
		      input : PLAIN_TEXT_FILE
		      i : INTEGER
	do
		  create input.make_open_read("input.txt") --Taking input from input.txt
	      input.read_word
	      len:=input.last_string.to_integer
	      create u_ar.make_filled(0,1,len)	--Initialsing arrays
	      create s_ar.make_filled(0,1,len)
	      from input.read_integer ; i := 0
	      until input.off	loop
	        i := i + 1
	        u_ar.put(input.last_integer,i)
	        input.read_integer
		  end
		  s_ar:=Heap_sort(u_ar)	--calling heapsort and printing on output.txt
		  print_h(s_ar)
		input.close

		rescue	--This gets executed if there are any violations in any assertions (It executes when len<=0 and prints INVALID message)
			create output.make_open_write("output.txt")
			output.put_string ("INVALID")
	end

feature {NONE}	--Heapsort arguments won't be exported (private)
	ensure_sorted:BOOLEAN	--Function to check whether array is in sorted order
		require
				not_empty_array : not s_ar.is_empty	--Pre conditions
		local i:INTEGER
	do
		Result:=True
		from i:=1 invariant len>0	until i>len-1 or Result=false loop
			if s_ar[i]>s_ar[i+1] then
				Result:=false
			end
			i:=i+1
		end
		ensure Result=true or Result=false	--Post conditions
	end

	Heap_sort(arr:ARRAY[INTEGER]):ARRAY[INTEGER]	--Function to create heap from input using MIN_HEAP class and return
													-- sorted array
		require
			not_empty_array : not arr.is_empty
			local i:INTEGER
		do
			create heap.make(arr,len)
			heap.build_min_h	--builds heap from given array elements
			from i:=1 invariant len>0 until i>len loop
						s_ar[i]:=heap.peek	--peek element and store in a array, this is the sorted array.
						heap.remove
						i:=i+1
						variant len-i+1
					end
			Result:=s_ar
			ensure array_not_empty: not s_ar.is_empty and ensure_sorted=true	--Post conditions
		end


		print_h(arr:ARRAY[INTEGER])	--Function to print Heap in output.txt
		require not_empty_arr: not arr.is_empty
		local i:INTEGER
		do
			create output.make_open_write("output.txt")
				from i:=1 until i>arr.count loop
					output.put_integer(arr[i])
					output.put_string(" ")
					i:=i+1
				end
			rescue
			create output.make_open_write("output.txt")
			output.put_string ("INVALID")
		end

	invariant len>0 --class invariant
end
