note
	description: "Chineese_remainder_theorem application root class"
	Instructions:"Please Check that If one provides an invalid input the program executes and stops by saying pre-conditon violation, output.txt file gets generated which shows INVALID, I used rescue clause to do that"
	Author: "Akash Tadwai"
	date: "$15-11-19$"
	revision: "$Revision$"

class
	ES18BTECH11019

inherit
	ARGUMENTS_32

create
	make
feature
	len:INTEGER
	rem:ARRAY[INTEGER] --remainder array
	num:ARRAY[INTEGER] --number array
	output : PLAIN_TEXT_FILE --Output file to be generated
	make
		local		-- taking input from user and storing in arrays
      input : PLAIN_TEXT_FILE
      i : INTEGER
    do
      create input.make_open_read("input.txt")
      create output.make_open_write("output.txt")
      input.read_integer
      len:=input.last_integer
      create num.make_filled(0,1,len)--Initialising arrays to 0
      create rem.make_filled(0,1,len)
      from input.read_integer ; i :=1 invariant len>0
      until input.off
      loop
        	num.put(input.last_integer,i)
        input.read_integer
        	rem.put(input.last_integer,i)
        input.read_integer
        i := i + 1
        variant len-i+1
        end
      input.close
	  output.put_integer(findmin) --Print output in txt file, if any contract fails rescue will be executed


			rescue	--This is executed when there is a assertion/contract violation in any of the routines.
			create output.make_open_write("output.txt")
			output.put_string ("INVALID")
	end


		isvalid :BOOLEAN --Final condition to check whether x%num[i]=rem[i] and 0<=rem[i]<num[i] for all 1<=i<=len
			require valid_dim:len>0	--precondition
			local i:INTEGER
		do
			Result:=true
			from i:=1 invariant not num.is_empty and not rem.is_empty and len>0  until i>len or Result=false loop
				if (findmin\\num[i]/=rem[i] and (rem[i]<0 or rem[i]>=num[i])) then
					Result:=false
				end
				i:=i+1
				variant len-i+1
			end
			ensure Result=true or Result=false	--postcondition
		end

		gcd (x: INTEGER y: INTEGER): INTEGER --Euclid's algorithm to find GCD of two numbers
			require x>0 and y>=0	--precondition
		do
			if y = 0 then
				Result := x
			else
				Result := gcd (y, x \\ y);
			end
			ensure x\\Result=0 and y\\Result=0 and Result>0	--post condition
		end

		pcoprime : BOOLEAN --Funciton to check whether all numbers are pairwise relatively prime
			require len>0 and not num.is_empty	--precondition
				local i,j,res:INTEGER
				do
					Result:=true
					from i:=1 invariant len>0 until i>=len or Result=false loop
						from j:=i+1 invariant len>0 until j>len or Result=false loop
							res:=gcd(num[i],num[j])
							if res=1 then	Result:=true
							else Result:=false
							end
							j:=j+1
							variant len-j+1
						end
					i:=i+1
					variant len-i+1
					end
					ensure Result=true or Result=false	--postcondition
				end


		inv(f,g:INTEGER): INTEGER -- Function to find moudlar multiplicative inverse
				require gcd(f,g)=1 and f>0 and g>0	--precondition
				local x0,x1,a,b,t,q:INTEGER
			do
				b:=g
				x0:=0
				x1:=1
				from	a:=f	--finding inverse by getting bezout's coefficients
				until	a<=1	loop
					q:=(a//b)
					t:=b
					b:=(a\\b)
					a:=t
					t:=x0
					x0:=(x1-q*x0)
					x1:=t
				end
				if x1<0 then
					x1:=x1+g
				end
				Result:=x1
				ensure (f*Result)\\g=1	--post condition
			end

		findmin :INTEGER --Function to find the result
			require not num.is_empty	--precondition
			local i,res,prod,pp:INTEGER
			flag:BOOLEAN
		do
				prod:=1
				from i:=1 invariant len>0 until i>len loop
						prod:=prod*num[i]
						i:=i+1
						variant len-i+1
					end
				res:=0
				from i:=1 invariant len>0 until i>len loop
						pp:=prod//num[i]
						res:=res+rem[i]*inv(pp,num[i])*pp
						i:=i+1
						variant len-i+1
					end
				Result:=res\\prod
				ensure isvalid=true	--postcondition validating the input sequence

		end

	invariant len>0 --class invariant

end
