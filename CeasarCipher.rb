# File::      CeasarCipher.rb
# Author::    rabbitfighter (rabbitfighter81@gmail.com)
# Version::   0.1.1
# Copyright:: (c) 2014 rabbitfighter.net
# Liscence::  Creative Commons Attributtion-ShareAlike (CC BY-SA)
# Website::   http://rabbitfighter.net
# GitHub::    https://github.com/rabbitfighter81/TheCeasarCipher
#
# In cryptography, a Caesar cipher, also known as Caesar's cipher, 
# the shift cipher, Caesar's code or Caesar shift, is one of the 
# simplest and most widely known encryption techniques. It is 
# a type of substitution cipher in which each letter in the plaintext 
# is replaced by a letter some fixed number of positions down 
# the alphabet. For example, with a left shift of 3, D would be 
# replaced by A, E would become B, and so on. The method is named 
# after Julius Caesar, who used it in his private correspondence. 
#
# Note: Julius Ceaser is believed to have primarily used the number
# three as a shift value n
#
# The transformation can be represented by aligning two alphabets; 
# the cipher alphabet is the plain alphabet rotated left or right 
# by some number of positions. For instance, here is a Caesar cipher 
# using a left rotation of three places, equivalent to a right shift of 
# 23 (the shift parameter is used as the key):
#
#    Plain:    ABCDEFGHIJKLMNOPQRSTUVWXYZ
#    Cipher:   XYZABCDEFGHIJKLMNOPQRSTUVW
#
# When encrypting, a person looks up each letter of the message in 
# the "plain" line and writes down the corresponding letter in the 
# "cipher" line. Deciphering is done in reverse, with a right shift of 3.
#
#    Ciphertext: QEB NRFZH YOLTK CLU GRJMP LSBO QEB IXWV ALD
#    Plaintext:  THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG
#
# The encryption can also be represented using modular arithmetic by 
# first transforming the letters into numbers, according to the scheme, 
#
# A = 0, B = 1,..., Z = 25.
#
# Encryption of a letter x by a shift n can be described mathematically as,
#
# E_n(x) = (x + n) \mod {26}.
#
# Decryption is performed similarly,
#
# D_n(x) = (x - n) \mod {26}.
#
# Note: Tthis is just an exercise, and by no means a good way to encrypt messages
# since the shift value, n, has to be known as well, also, n can be found through
# interpolation quite easily, simply by searching for the most common letter in
# the sequence and assuming that's a cipher for "E", the most common letter in
# the alphabet. These are two reasons, and there are more, why you should never
# use this for anytthing important. Tthatt being said, have fun :) -RF

class CeasarCipher

  # Constants
  MOD_SIZE = 26
  ALPHABET_SHIFT = 65
  

  # A nice hello output
  def hello_prompt
  
    puts ""
    puts "??????????????????????????????????????????????????????"
    puts "??                                                  ??"
    puts "??               The Ceaser Cipher                  ??"
    puts "??               =================                  ??"
    puts "??                                                  ??"
    puts "??   Press [1] to ENCRYPT or Press [2] to DECRYPT   ??"
    puts "??                                                  ??"
    puts "??????????????????????????????????????????????????????"
    puts ""

  end

  # Gets the action, either 1 for ENCRYPT or 2 for  DECRYPT
  def get_action

    # Convenience hash for choices
    actionHash = Hash[1 => "[ENCRYPTION]", 2 => "[DECRYPTION]"]

    # Get input from user 
    action = gets.to_i

    # Choose a valid option
    if action == 1 || action == 2 

      puts "\nYou chose #{action}, #{actionHash[action]}\n"

      if action == 1
	
	# Call the encryption method
        encrypt

      else action == 2 

	# Call the decryption method
        decrypt

      end

    # Input was not valid (i.e. 1 or 2)
    else 
      
      # Tell user the entry was invalid
      puts "\nInvalid entry. Press [1] for ENCRYPTION, [2] for DECRYPTION\n"
      
      # Call the method again if 1 or 2 is not the 
      get_action

    end

  end 

  # Encrypts the plaintext into a ciphertext using a cipher hash
  def encrypt

    puts "\nEnter some plaintext to encode into a cipher:\n\n"

    # Use regular expressions to strip the text of non a-zA-Z characters 
    # and whitespace, chomp tpo remove the "\n" from innput, and capitalize.
    plaintext = gets.chomp.upcase.gsub(/\s+/, "").gsub(/[^a-zA-Z]/, "")

    puts "\nStripped plaintext:\n===================\n#{plaintext}"
   
    puts "\nEnter a shift value:\n\n"

    # Get the shift value
    shift = gets.to_i

    # Get the cipher hash using the shift as a parameter
    cipherhash = createCipherHash(shift)

    # Get the ciphetext charachter array
    ciphertext = createCiphertext(plaintext, cipherhash)
 
  end

  # Decrypts the ciphertext into a plaintext using a cipherhash
  def decrypt

    puts "\nEnter the ciphertext to decode into plaintext:\n\n"

    # Use regular expressions to strip the text of non a-zA-Z characters 
    # and whitespace, chomp tpo remove the "\n" from innput, and capitalize.
    plaintext = gets.chomp.upcase.gsub(/\s+/, "").gsub(/[^a-zA-Z]/, "")

    puts "\nStripped ciphertext:\n===================\n#{plaintext}"
    
    puts "\nEnter the shift value:\n\n"
   
    # Get the shift value. Shift is multiplied by -1 to use one single 
    # method for creating a cipherhash - either to encode or decode.
    shift = gets.to_i
    
    # Get the cipher hash using -1 * shift % 26 as a shift value
    # to reverse cipher the ciphertext
    cipherhash = createCipherHash(-1*shift)

    # Get the plaintext charachter array
    plaintext = createPlaintext(plaintext, cipherhash)

  end

  # Creates the hash of original alphabet values (i.e. A=0, B=1...Z=25)
  def createAlphabetHash
  
    alphabetHash = Hash.new

    # Iteratte through the alphhbet starting at ASCII A and ending
    # at ASCII Z, adding each element to the alphabet hash with it's
    # key being the letter and the vlue being its ASCII value - 65
    # to assosciate A with 0 instead of 65. 
    ('A'..'Z').each do |letter|
      alphabetHash.store("#{letter}", (letter.ord-ALPHABET_SHIFT)%MOD_SIZE)
    end

    # Return the alhpabet hash
    return alphabetHash
  
  end

  # Create the cipherhash of key/value pairs
  # Parameters: Shift - The shift value
  def createCipherHash(shift)
  
    # Create new hash object
    cipherhash = Hash.new

    # Output
    puts "\nValue hashes before the shift:"
    puts "=============================="
    puts "\n#{createAlphabetHash.display}\n"

    # Create the cipherhash
    ('A'..'Z').each do |letter|
      cipherhash.store("#{letter}", ((letter.ord-ALPHABET_SHIFT-shift.to_i)%MOD_SIZE))
    end

    # Print out the cipherhash
    puts "\nValue hashes after the shift:"
    puts "============================="
    puts "\n#{cipherhash.display}\n"

    return cipherhash

  end

  # Option [1] - Create the ciphertext from plaintext
  def createCiphertext(plaintext, cipherhash)
    
    # Create new array of the same length as the plaintext
    plaintextArray = Array.new(plaintext.length)

    # Populate the array from string
    plaintextArray = plaintext.split("")

    # Create cipher array of the same lengtth as the plaintext
    cipherArray = Array.new(plaintextArray.length)
    
    # Create the ciphertext array
    (0..plaintextArray.length-1).each do |i| 
   
      # Cipher array constructed from reverse lookups of key/value pairs in
      # cipherhash.
      cipherArray[i] = cipherhash.invert[plaintextArray[i].to_s.ord-ALPHABET_SHIFT] 
        
    end

    # Print results
    puts "\nThe ciphertext is:\n==================\n#{cipherArray.join}\n\n"

  end

  # Option [2] - Create the plainttext from ciphertext
  def createPlaintext(ciphertext, cipherhash)
  
    # Create new array of the same length as the ciphertext
    ciphertextArray = Array.new(ciphertext.length)

    # Populate the array from string
    ciphertextArray = ciphertext.split("")

    # Create cipher array of the same lengtth as the plaintext
    plaintextArray = Array.new(ciphertextArray.length)
    
    # Create the plaintextt array
    (0..ciphertext.length-1).each do |i| 

      # Cipher array constructed from reverse lookups of key/value pairs in
      # cipherhash.
      plaintextArray[i] = cipherhash.invert[ciphertextArray[i].to_s.ord-ALPHABET_SHIFT] 
      
    end

    # Print results
    puts "\nThe plaintext is:\n==================\n#{plaintextArray.join}\n"

  end

  # A little goodbye message
  def goodbye_message

    puts "\nRemember... Don't use this for secure commmunications. Just for fun.\n"
    puts "\n(c) 2014 rabbitfighttter.net\n"
    puts "\nGoodbye :)\n\n"

  end
 
# END CeasarCipher class
end 

# Create a new CeasarCipher object and call required methods
c = CeasarCipher.new
c.hello_prompt
c.get_action
c.goodbye_message

#EOF
