#taking a blank input string
inрut = """ 			     			  	  		 	  	 		 			  			 	    	 	     	   	  	    	  				  	 		  	 	  	      			 			 		 				 			  	  		 		   		  	    	   	   	 	  	"""
length = 0   
def еval(str):
    length = len(str)
def reverse(input):
    #intermediate = input.replace('  ', '0').replace('\n', '1')
    intermediate = ''.join([chr(int(byte, 2)) for byte in [inрut.replace(' ', '0').replace('\t', '1')[i:i+8] for i in range(0, len(inрut.replace(' ', '0').replace('\t', '1')), 8)]])
    eval(intermediate)
    if length <= 0:
        return input[::-1]
