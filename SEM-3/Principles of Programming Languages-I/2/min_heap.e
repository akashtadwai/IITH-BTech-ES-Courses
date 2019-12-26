note
	description: "Min heap and heap sort, Reference: CLRS"
	author: "Akash Tadwai"
	date: "$16-11-19$"
	revision: "$Revision$"

class
	MIN_HEAP

create
	make

feature
	len:INTEGER
	u_ar:ARRAY[INTEGER]	--array representing unsorted array of integers
	c_size:INTEGER		--Attribute representing intermediate size of the Heap

	make(arr:ARRAY[INTEGER] l:INTEGER)	--Function to assign Inputs
		local
			i: INTEGER
		do
			c_size:=l
			len:=l
			create u_ar.make_filled(0,1,l)
			from i:=1 until i>l loop
	     		u_ar[i]:=arr[i]
	     		i:=i+1
			end
		ensure
			len_equal : len = l
		end

feature

	is_min_heap:BOOLEAN	--Function to check a min-heap
		local i:INTEGER
		do
		Result:=true
			from i:=1 invariant len>0	until Result=false or (i>c_size//2	and c_size\\2=1) or (i>=c_size//2 and c_size\\2=0) loop	--It checks whether a given array is a minheap
			if u_ar[i]>u_ar[Left(i)] or u_ar[i]>u_ar[Right(i)] then
				Result:=false
			end
			i:=i+1
			variant len-i+1
			end
			ensure Result=true or Result=false
		end

	Parent(i:INTEGER): INTEGER
		require index: i>0
	do
		Result:=i//2
		ensure result_set : Result=i//2
	end

	Left(i:INTEGER) : INTEGER
		require index: i>0
		do
			Result:=2*i
			ensure result_set : Result=2*i
		end
	Right(i:INTEGER) : INTEGER
		require index: i>0
		do
			Result:=2*i+1
			ensure result_set : Result=2*i+1
		end
	min_heapify(i:INTEGER) --min-heapify implementation (Ref: CLRS)
		require i>0 and i<=c_size
		local l,r,smallest,flag:INTEGER
		do
			l:=Left(i)
			r:=Right(i)
			if l<=c_size and u_ar[l]<u_ar[i] then --Finding smallest node
				smallest:=l
			else smallest:=i
			end
			if r<=c_size and u_ar[r]<u_ar[smallest] then
				smallest:=r
			end
			if smallest/=i then	--swap u_ar[i] and u_ar[smallest] and recurse (go up)
				flag:=u_ar[i]
				u_ar[i]:=u_ar[smallest]
				u_ar[smallest]:=flag
				min_heapify(smallest)
			end
		end

	build_min_h	--Building heap from array
		require len>0
			local i:INTEGER
	do
		from i:=len//2 until i<1	loop
			min_heapify(i)
			i:=i-1
		end
		ensure is_min_heap=true
	end

	peek : INTEGER	--Returns top element of heap
	require not u_ar.is_empty
	do
		Result:=u_ar[1]
		ensure peek_proper_set: Result=u_ar[1]
	end

	insert(key:INTEGER)	--Insert element into heap
	require len>0
	local flag:INTEGER;i:INTEGER
	do
		c_size:=c_size+1
		u_ar[c_size]:=key
		from i:=c_size invariant c_size>=0	until i=1 and (u_ar[Parent(i)] > u_ar[i])	loop
			flag:=u_ar[Parent(i)]
			u_ar[Parent(i)]:=u_ar[i]
			u_ar[i]:=flag
			i:=Parent(i)
		end
		ensure c_size=old c_size+1 and is_min_heap=true
	end

	remove	--remove element from heap
		require not u_ar.is_empty
	do
		u_ar[1]:=u_ar[c_size]
		c_size:=c_size-1

			if c_size>0 then
				min_heapify(1)

			end
		ensure key_added: c_size=old c_size-1 and is_min_heap=true
	end

	size : INTEGER
		require	valid_size: c_size>0
		do
			Result:=c_size
			ensure size_properly_set: Result=c_size
		end

	invariant len>0 --class invariant

end
