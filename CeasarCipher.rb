#!/usr/bin/env ruby
#
# Author:: rabbitfighter (rabbitfighter81@gmail.com)
# Version:: 0.1.0
# Copyright:: (c) 2014 rabbitfighter.net
# Liscence:: Creative Commons Attributtion-ShareAlike (CC BY-SA)
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
# Note: This is just an exercise, and by no means a good way to encrypt messages
# since the shift value, n, has to be known as well, also, n can be found through
# interpolation quite easily, simply by searching for the most common letter in
# the sequence and assuming that's a cipher for "E", the most common letter in
# the alphabet. These are two reasons, and there are more, why you should never
# use this for anytthing important. That being said, have fun :) -RF

class CeasarCipher

  # Constants
  MOD_SIZE = 26
  ALPHABET_SHIFT = 65
  

  # A nice hello screen
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

  def createAlphabetHash
  
    alphabetHash = Hash.new

    ('A'..'Z').each do |letter|
      alphabetHash.store("#{letter}", (letter.ord-ALPHABET_SHIFT)%MOD_SIZE)
    end

    puts alphabetHash.display
    
    # Return the alhpabet 
    return alphabetHash
  
  end

  # Gets the action, either 1 for ENCRYPT or 2 for  DECRYPT
  def get_action

    # Convenience hash for choices
    actionHash = Hash[1 => "[ENCRYPTION]", 2 => "[DECRYPTION]"]

    # Get input from user 
    action = gets.to_i

    # If it's a valid option, continue, else not...
    if action == 1 || action == 2 

      puts "\nYou chose #{action}, #{actionHash[action]}\n"

      if action == 1
	
	# Call the encryption method (commented out for now)
        encrypt

      else action == 2 

	# Call the decryption method (commented out for now)
        decrypt

      end

    else 
      
      # Tell user the entry was invalid
      puts "\nInvalid entry. Press [1] for ENCRYPTION, [2] for DECRYPTION\n"
      
      # Call the method again (commented out)
      # get_action()

    end

  end 

  # Encrypts the plaintext into a cipher
  def encrypt

    # Get the message
    puts "\nEnter some plaintext to encode into a cipher:\n\n"
    plaintext = gets.chomp.upcase.gsub(/\s+/, "")

    puts "\nStripped plaintext:\n===================\n#{plaintext}"
    # Get the shift value
    puts "\nEnter a shift value:\n\n"
    shift = gets

    # Get the cipher hash
    cipherhash = createCipherHash(shift)

    # Get the charachter array
    ciphertext = createCiphertext(plaintext, cipherhash)
 
  end

  # Decrypts the cipher into a plaintext
  def decrypt

     # Get the message
    puts "\nEnter the ciphertext to decode into plaintext:\n\n"
    plaintext = gets.chomp.upcase.gsub(/\s+/, "")

    puts "\nStripped ciphertext:\n===================\n#{plaintext}"
    # Get the shift value
    puts "\nEnter the shift value:\n\n"
   
    # Shift is multiplied by -1 to use one metthod for creating a cipherhash, either
    # to encode or decode.
    shift = gets.to_i
    
    # Get the cipher hash
    cipherhash = createCipherHash(-1*shift)

    # Get the charachter array
    plaintext = createPlaintext(plaintext, cipherhash)

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
    
    plaintextArray = Array.new(plaintext.length)

    plaintextArray = plaintext.split("")

    # Create cipher array of the same lengtth as the plaintext
    cipherArray = Array.new(plaintextArray.length)
    
    # Create the ciphertext
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
  
    ciphertextArray = Array.new(ciphertext.length)

    ciphertextArray = ciphertext.split("")

    # Create cipher array of the same lengtth as the plaintext
    plaintextArray = Array.new(ciphertextArray.length)
    
    # Create the ciphertext
    (0..ciphertext.length-1).each do |i| 

      # Cipher array constructed from reverse lookups of key/value pairs in
      # cipherhash.
      plaintextArray[i] = cipherhash.invert[ciphertextArray[i].to_s.ord-ALPHABET_SHIFT] 
      
    end

    # Print results
    puts "\nThe plaintext is:\n==================\n#{plaintextArray.join}\n\n"

  end
 
end 

c = CeasarCipher.new
c.hello_prompt
c.get_action
c.goodbye
