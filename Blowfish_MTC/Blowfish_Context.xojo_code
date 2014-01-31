#tag Class
Protected Class Blowfish_Context
	#tag Method, Flags = &h21
		Private Sub BLFRND(ByRef i As UInt32, j As UInt32, n As Integer)
		  #pragma BackgroundTasks False
		  
		  dim a, b, c, d As Integer
		  
		  static mb as new MemoryBlock( 4 )
		  static pt as Ptr = mb
		  static isLittleEndian as boolean = mb.LittleEndian
		  
		  pt.UInt32( 0 ) = j
		  
		  if isLittleEndian then
		    a = pt.Byte( 3 )
		    b = pt.Byte( 2 )
		    c = pt.Byte( 1 )
		    d = pt.Byte( 0 )
		  else
		    a = pt.Byte( 0 )
		    b = pt.Byte( 1 )
		    c = pt.Byte( 2 )
		    d = pt.Byte( 3 )
		  end if
		  
		  j = S( 0, a ) + S( 1, b )
		  j = j Xor S( 2, c )
		  j = j + S( 3, d )
		  
		  i = i Xor ( j Xor P( n ) )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  for i as integer = 0 to 3
		    dim arr() as UInt32
		    select case i
		    case 0
		      arr = S0
		    case 1
		      arr = S1
		    case 2
		      arr = S2
		    case 3
		      arr = S3
		    end
		    
		    for i1 as Integer = 0 to arr.Ubound
		      S( i, i1 ) = arr( i1 )
		    next i1
		  next i
		  
		  P = Array( _
		  &h243f6a88, &h85a308d3, &h13198a2e, &h03707344, _
		  &ha4093822, &h299f31d0, &h082efa98, &hec4e6c89, _
		  &h452821e6, &h38d01377, &hbe5466cf, &h34e90c6c, _
		  &hc0ac29b7, &hc97c50dd, &h3f84d5b5, &hb5470917, _
		  &h9216d5d9, &h8979fb1b _
		  )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Decipher(ByRef Xl As UInt32, ByRef Xr As Uint32)
		  // The main loop for processing Decipher
		  
		  Xl = Xl Xor self.P( 17 )
		  BLFRND( Xr, Xl, 16 )
		  BLFRND( Xl, Xr, 15 )
		  BLFRND( Xr, Xl, 14 )
		  BLFRND( Xl, Xr, 13 )
		  BLFRND( Xr, Xl, 12 )
		  BLFRND( Xl, Xr, 11 )
		  BLFRND( Xr, Xl, 10 )
		  BLFRND( Xl, Xr, 9 )
		  BLFRND( Xr, Xl, 8 )
		  BLFRND( Xl, Xr, 7 )
		  BLFRND( Xr, Xl, 6 )
		  BLFRND( Xl, Xr, 5 )
		  BLFRND( Xr, Xl, 4 )
		  BLFRND( Xl, Xr, 3 )
		  BLFRND( Xr, Xl, 2 )
		  BLFRND( Xl, Xr, 1 )
		  Xr = Xr Xor self.P( 0 )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Decipher(mb As Ptr, byteIndex As Integer)
		  dim Xl, Xr as UInt32
		  
		  Xl = mb.UInt32( byteIndex )
		  Xr = mb.UInt32( byteIndex + 4 )
		  
		  Decipher( Xl, Xr )
		  
		  mb.UInt32( byteIndex ) = Xr
		  mb.UInt32( byteIndex + 4 ) = Xl
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Decipher(x() As UInt32)
		  dim Xl, Xr as UInt32
		  
		  Xl = x( 0 )
		  Xr = x( 1 )
		  
		  Decipher( Xl, Xr )
		  
		  X( 0 ) = Xr
		  X( 1 ) = Xl
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Decrypt(data As MemoryBlock)
		  #pragma BackgroundTasks False
		  
		  dim p as Ptr = data
		  dim lastByteIndex as Integer = data.Size - 1
		  for byteIndex as Integer = 0  to lastByteIndex step 8
		    Decipher( p, byteIndex )
		  next byteIndex
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Encipher(ByRef x0 As UInt32, ByRef x1 As UInt32)
		  // The main loop for processing Encipher
		  
		  dim Xl as UInt32 = x0
		  dim Xr as Uint32 = x1
		  
		  Xl = Xl Xor self.P( 0 )
		  BLFRND( Xr, Xl, 1 )
		  BLFRND( Xl, Xr, 2 )
		  BLFRND( Xr, Xl, 3 )
		  BLFRND( Xl, Xr, 4 )
		  BLFRND( Xr, Xl, 5 )
		  BLFRND( Xl, Xr, 6 )
		  BLFRND( Xr, Xl, 7 )
		  BLFRND( Xl, Xr, 8 )
		  BLFRND( Xr, Xl, 9 )
		  BLFRND( Xl, Xr, 10 )
		  BLFRND( Xr, Xl, 11 )
		  BLFRND( Xl, Xr, 12 )
		  BLFRND( Xr, Xl, 13 )
		  BLFRND( Xl, Xr, 14 )
		  BLFRND( Xr, Xl, 15 )
		  BLFRND( Xl, Xr, 16 )
		  Xr = Xr Xor self.P( 17 )
		  
		  x0 = Xr
		  x1 = Xl
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Encipher(mb As Ptr, byteIndex As Integer)
		  #pragma BackgroundTasks False
		  
		  dim Xl, Xr as UInt32
		  
		  Xl = mb.UInt32( byteIndex )
		  Xr = mb.UInt32( byteIndex + 4 )
		  
		  Encipher( Xl, Xr )
		  
		  mb.UInt32( byteIndex ) = Xl
		  mb.UInt32( byteIndex + 4 ) = Xr
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Encipher(x() As UInt32)
		  #pragma BackgroundTasks False
		  
		  dim Xl, Xr as UInt32
		  
		  Xl = x( 0 )
		  Xr = x( 1 )
		  
		  Encipher( Xl, Xr )
		  
		  x( 0 ) = Xl
		  x( 1 ) = Xr
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Encrypt(data As MemoryBlock)
		  #pragma BackgroundTasks False
		  
		  dim p as Ptr = data
		  dim lastByteIndex as Integer = data.Size - 1
		  for byteIndex as Integer = 0 to lastByteIndex step 8
		    Encipher( p, byteIndex )
		  next byteIndex
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Expand0State(key As MemoryBlock)
		  #pragma BackgroundTasks False
		  
		  dim i, j, k as UInt16
		  dim temp as UInt32
		  dim d0, d1 as UInt32
		  
		  static lastIndex as integer = P.Ubound
		  for i = 0 to lastIndex
		    temp = Stream2Word( key, j )
		    self.P( i ) = self.P( i ) Xor temp
		  next i
		  
		  j = 0
		  for i = 0 to lastIndex step 2
		    Encipher( d0, d1 )
		    self.P( i ) = d0
		    self.P( i + 1 ) = d1
		  next i
		  
		  for i = 0 to 3
		    for k = 0 to 255 step 2
		      Encipher( d0, d1 )
		      
		      self.S( i, k ) = d0
		      self.S( i, k + 1 ) = d1
		    next k
		  next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExpandState(data As MemoryBlock, key As MemoryBlock)
		  #pragma BackgroundTasks False
		  
		  dim i, j, k as UInt16
		  dim temp as UInt32
		  dim d( 1 ) as UInt32
		  
		  dim lastIndex as Integer = BLF_N + 1
		  for i = 0 to lastIndex
		    temp = Stream2Word( key, j )
		    self.P( i ) = self.P( i ) Xor temp
		  next i
		  
		  j = 0
		  for i = 0 to lastIndex step 2
		    d( 0 ) = d( 0 ) Xor Stream2Word( data, j )
		    d( 1 ) = d( 1 ) Xor Stream2Word( data, j )
		    Encipher( d )
		    
		    self.P( i ) = d( 0 )
		    self.P( i + 1 ) = d( 1 )
		  next i
		  
		  for i = 0 to 3
		    for k = 0 to 255 step 2
		      d( 0 ) = d( 0 ) Xor Stream2Word( data, j )
		      d( 1 ) = d( 1 ) Xor Stream2Word( data, j )
		      Encipher( d )
		      
		      self.S( i, k ) = d( 0 )
		      self.S( i, k + 1 ) = d( 1 )
		    next k
		  next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function S0() As UInt32()
		  return Array( _
		  &hd1310ba6, &h98dfb5ac, &h2ffd72db, &hd01adfb7, _
		  &hb8e1afed, &h6a267e96, &hba7c9045, &hf12c7f99, _
		  &h24a19947, &hb3916cf7, &h0801f2e2, &h858efc16, _
		  &h636920d8, &h71574e69, &ha458fea3, &hf4933d7e, _
		  &h0d95748f, &h728eb658, &h718bcd58, &h82154aee, _
		  &h7b54a41d, &hc25a59b5, &h9c30d539, &h2af26013, _
		  &hc5d1b023, &h286085f0, &hca417918, &hb8db38ef, _
		  &h8e79dcb0, &h603a180e, &h6c9e0e8b, &hb01e8a3e, _
		  &hd71577c1, &hbd314b27, &h78af2fda, &h55605c60, _
		  &he65525f3, &haa55ab94, &h57489862, &h63e81440, _
		  &h55ca396a, &h2aab10b6, &hb4cc5c34, &h1141e8ce, _
		  &ha15486af, &h7c72e993, &hb3ee1411, &h636fbc2a, _
		  &h2ba9c55d, &h741831f6, &hce5c3e16, &h9b87931e, _
		  &hafd6ba33, &h6c24cf5c, &h7a325381, &h28958677, _
		  &h3b8f4898, &h6b4bb9af, &hc4bfe81b, &h66282193, _
		  &h61d809cc, &hfb21a991, &h487cac60, &h5dec8032, _
		  &hef845d5d, &he98575b1, &hdc262302, &heb651b88, _
		  &h23893e81, &hd396acc5, &h0f6d6ff3, &h83f44239, _
		  &h2e0b4482, &ha4842004, &h69c8f04a, &h9e1f9b5e, _
		  &h21c66842, &hf6e96c9a, &h670c9c61, &habd388f0, _
		  &h6a51a0d2, &hd8542f68, &h960fa728, &hab5133a3, _
		  &h6eef0b6c, &h137a3be4, &hba3bf050, &h7efb2a98, _
		  &ha1f1651d, &h39af0176, &h66ca593e, &h82430e88, _
		  &h8cee8619, &h456f9fb4, &h7d84a5c3, &h3b8b5ebe, _
		  &he06f75d8, &h85c12073, &h401a449f, &h56c16aa6, _
		  &h4ed3aa62, &h363f7706, &h1bfedf72, &h429b023d, _
		  &h37d0d724, &hd00a1248, &hdb0fead3, &h49f1c09b, _
		  &h075372c9, &h80991b7b, &h25d479d8, &hf6e8def7, _
		  &he3fe501a, &hb6794c3b, &h976ce0bd, &h04c006ba, _
		  &hc1a94fb6, &h409f60c4, &h5e5c9ec2, &h196a2463, _
		  &h68fb6faf, &h3e6c53b5, &h1339b2eb, &h3b52ec6f, _
		  &h6dfc511f, &h9b30952c, &hcc814544, &haf5ebd09, _
		  &hbee3d004, &hde334afd, &h660f2807, &h192e4bb3, _
		  &hc0cba857, &h45c8740f, &hd20b5f39, &hb9d3fbdb, _
		  &h5579c0bd, &h1a60320a, &hd6a100c6, &h402c7279, _
		  &h679f25fe, &hfb1fa3cc, &h8ea5e9f8, &hdb3222f8, _
		  &h3c7516df, &hfd616b15, &h2f501ec8, &had0552ab, _
		  &h323db5fa, &hfd238760, &h53317b48, &h3e00df82, _
		  &h9e5c57bb, &hca6f8ca0, &h1a87562e, &hdf1769db, _
		  &hd542a8f6, &h287effc3, &hac6732c6, &h8c4f5573, _
		  &h695b27b0, &hbbca58c8, &he1ffa35d, &hb8f011a0, _
		  &h10fa3d98, &hfd2183b8, &h4afcb56c, &h2dd1d35b, _
		  &h9a53e479, &hb6f84565, &hd28e49bc, &h4bfb9790, _
		  &he1ddf2da, &ha4cb7e33, &h62fb1341, &hcee4c6e8, _
		  &hef20cada, &h36774c01, &hd07e9efe, &h2bf11fb4, _
		  &h95dbda4d, &hae909198, &heaad8e71, &h6b93d5a0, _
		  &hd08ed1d0, &hafc725e0, &h8e3c5b2f, &h8e7594b7, _
		  &h8ff6e2fb, &hf2122b64, &h8888b812, &h900df01c, _
		  &h4fad5ea0, &h688fc31c, &hd1cff191, &hb3a8c1ad, _
		  &h2f2f2218, &hbe0e1777, &hea752dfe, &h8b021fa1, _
		  &he5a0cc0f, &hb56f74e8, &h18acf3d6, &hce89e299, _
		  &hb4a84fe0, &hfd13e0b7, &h7cc43b81, &hd2ada8d9, _
		  &h165fa266, &h80957705, &h93cc7314, &h211a1477, _
		  &he6ad2065, &h77b5fa86, &hc75442f5, &hfb9d35cf, _
		  &hebcdaf0c, &h7b3e89a0, &hd6411bd3, &hae1e7e49, _
		  &h00250e2d, &h2071b35e, &h226800bb, &h57b8e0af, _
		  &h2464369b, &hf009b91e, &h5563911d, &h59dfa6aa, _
		  &h78c14389, &hd95a537f, &h207d5ba2, &h02e5b9c5, _
		  &h83260376, &h6295cfa9, &h11c81968, &h4e734a41, _
		  &hb3472dca, &h7b14a94a, &h1b510052, &h9a532915, _
		  &hd60f573f, &hbc9bc6e4, &h2b60a476, &h81e67400, _
		  &h08ba6fb5, &h571be91f, &hf296ec6b, &h2a0dd915, _
		  &hb6636521, &he7b9f9b6, &hff34052e, &hc5855664, _
		  &h53b02d5d, &ha99f8fa1, &h08ba4799, &h6e85076a _
		  )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function S1() As UInt32()
		  return Array( _
		  &h4b7a70e9, &hb5b32944, &hdb75092e, &hc4192623, _
		  &had6ea6b0, &h49a7df7d, &h9cee60b8, &h8fedb266, _
		  &hecaa8c71, &h699a17ff, &h5664526c, &hc2b19ee1, _
		  &h193602a5, &h75094c29, &ha0591340, &he4183a3e, _
		  &h3f54989a, &h5b429d65, &h6b8fe4d6, &h99f73fd6, _
		  &ha1d29c07, &hefe830f5, &h4d2d38e6, &hf0255dc1, _
		  &h4cdd2086, &h8470eb26, &h6382e9c6, &h021ecc5e, _
		  &h09686b3f, &h3ebaefc9, &h3c971814, &h6b6a70a1, _
		  &h687f3584, &h52a0e286, &hb79c5305, &haa500737, _
		  &h3e07841c, &h7fdeae5c, &h8e7d44ec, &h5716f2b8, _
		  &hb03ada37, &hf0500c0d, &hf01c1f04, &h0200b3ff, _
		  &hae0cf51a, &h3cb574b2, &h25837a58, &hdc0921bd, _
		  &hd19113f9, &h7ca92ff6, &h94324773, &h22f54701, _
		  &h3ae5e581, &h37c2dadc, &hc8b57634, &h9af3dda7, _
		  &ha9446146, &h0fd0030e, &hecc8c73e, &ha4751e41, _
		  &he238cd99, &h3bea0e2f, &h3280bba1, &h183eb331, _
		  &h4e548b38, &h4f6db908, &h6f420d03, &hf60a04bf, _
		  &h2cb81290, &h24977c79, &h5679b072, &hbcaf89af, _
		  &hde9a771f, &hd9930810, &hb38bae12, &hdccf3f2e, _
		  &h5512721f, &h2e6b7124, &h501adde6, &h9f84cd87, _
		  &h7a584718, &h7408da17, &hbc9f9abc, &he94b7d8c, _
		  &hec7aec3a, &hdb851dfa, &h63094366, &hc464c3d2, _
		  &hef1c1847, &h3215d908, &hdd433b37, &h24c2ba16, _
		  &h12a14d43, &h2a65c451, &h50940002, &h133ae4dd, _
		  &h71dff89e, &h10314e55, &h81ac77d6, &h5f11199b, _
		  &h043556f1, &hd7a3c76b, &h3c11183b, &h5924a509, _
		  &hf28fe6ed, &h97f1fbfa, &h9ebabf2c, &h1e153c6e, _
		  &h86e34570, &heae96fb1, &h860e5e0a, &h5a3e2ab3, _
		  &h771fe71c, &h4e3d06fa, &h2965dcb9, &h99e71d0f, _
		  &h803e89d6, &h5266c825, &h2e4cc978, &h9c10b36a, _
		  &hc6150eba, &h94e2ea78, &ha5fc3c53, &h1e0a2df4, _
		  &hf2f74ea7, &h361d2b3d, &h1939260f, &h19c27960, _
		  &h5223a708, &hf71312b6, &hebadfe6e, &heac31f66, _
		  &he3bc4595, &ha67bc883, &hb17f37d1, &h018cff28, _
		  &hc332ddef, &hbe6c5aa5, &h65582185, &h68ab9802, _
		  &heecea50f, &hdb2f953b, &h2aef7dad, &h5b6e2f84, _
		  &h1521b628, &h29076170, &hecdd4775, &h619f1510, _
		  &h13cca830, &heb61bd96, &h0334fe1e, &haa0363cf, _
		  &hb5735c90, &h4c70a239, &hd59e9e0b, &hcbaade14, _
		  &heecc86bc, &h60622ca7, &h9cab5cab, &hb2f3846e, _
		  &h648b1eaf, &h19bdf0ca, &ha02369b9, &h655abb50, _
		  &h40685a32, &h3c2ab4b3, &h319ee9d5, &hc021b8f7, _
		  &h9b540b19, &h875fa099, &h95f7997e, &h623d7da8, _
		  &hf837889a, &h97e32d77, &h11ed935f, &h16681281, _
		  &h0e358829, &hc7e61fd6, &h96dedfa1, &h7858ba99, _
		  &h57f584a5, &h1b227263, &h9b83c3ff, &h1ac24696, _
		  &hcdb30aeb, &h532e3054, &h8fd948e4, &h6dbc3128, _
		  &h58ebf2ef, &h34c6ffea, &hfe28ed61, &hee7c3c73, _
		  &h5d4a14d9, &he864b7e3, &h42105d14, &h203e13e0, _
		  &h45eee2b6, &ha3aaabea, &hdb6c4f15, &hfacb4fd0, _
		  &hc742f442, &hef6abbb5, &h654f3b1d, &h41cd2105, _
		  &hd81e799e, &h86854dc7, &he44b476a, &h3d816250, _
		  &hcf62a1f2, &h5b8d2646, &hfc8883a0, &hc1c7b6a3, _
		  &h7f1524c3, &h69cb7492, &h47848a0b, &h5692b285, _
		  &h095bbf00, &had19489d, &h1462b174, &h23820e00, _
		  &h58428d2a, &h0c55f5ea, &h1dadf43e, &h233f7061, _
		  &h3372f092, &h8d937e41, &hd65fecf1, &h6c223bdb, _
		  &h7cde3759, &hcbee7460, &h4085f2a7, &hce77326e, _
		  &ha6078084, &h19f8509e, &he8efd855, &h61d99735, _
		  &ha969a7aa, &hc50c06c2, &h5a04abfc, &h800bcadc, _
		  &h9e447a2e, &hc3453484, &hfdd56705, &h0e1e9ec9, _
		  &hdb73dbd3, &h105588cd, &h675fda79, &he3674340, _
		  &hc5c43465, &h713e38d8, &h3d28f89e, &hf16dff20, _
		  &h153e21e7, &h8fb03d4a, &he6e39f2b, &hdb83adf7 _
		  )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function S2() As UInt32()
		  return Array( _
		  &he93d5a68, &h948140f7, &hf64c261c, &h94692934, _
		  &h411520f7, &h7602d4f7, &hbcf46b2e, &hd4a20068, _
		  &hd4082471, &h3320f46a, &h43b7d4b7, &h500061af, _
		  &h1e39f62e, &h97244546, &h14214f74, &hbf8b8840, _
		  &h4d95fc1d, &h96b591af, &h70f4ddd3, &h66a02f45, _
		  &hbfbc09ec, &h03bd9785, &h7fac6dd0, &h31cb8504, _
		  &h96eb27b3, &h55fd3941, &hda2547e6, &habca0a9a, _
		  &h28507825, &h530429f4, &h0a2c86da, &he9b66dfb, _
		  &h68dc1462, &hd7486900, &h680ec0a4, &h27a18dee, _
		  &h4f3ffea2, &he887ad8c, &hb58ce006, &h7af4d6b6, _
		  &haace1e7c, &hd3375fec, &hce78a399, &h406b2a42, _
		  &h20fe9e35, &hd9f385b9, &hee39d7ab, &h3b124e8b, _
		  &h1dc9faf7, &h4b6d1856, &h26a36631, &heae397b2, _
		  &h3a6efa74, &hdd5b4332, &h6841e7f7, &hca7820fb, _
		  &hfb0af54e, &hd8feb397, &h454056ac, &hba489527, _
		  &h55533a3a, &h20838d87, &hfe6ba9b7, &hd096954b, _
		  &h55a867bc, &ha1159a58, &hcca92963, &h99e1db33, _
		  &ha62a4a56, &h3f3125f9, &h5ef47e1c, &h9029317c, _
		  &hfdf8e802, &h04272f70, &h80bb155c, &h05282ce3, _
		  &h95c11548, &he4c66d22, &h48c1133f, &hc70f86dc, _
		  &h07f9c9ee, &h41041f0f, &h404779a4, &h5d886e17, _
		  &h325f51eb, &hd59bc0d1, &hf2bcc18f, &h41113564, _
		  &h257b7834, &h602a9c60, &hdff8e8a3, &h1f636c1b, _
		  &h0e12b4c2, &h02e1329e, &haf664fd1, &hcad18115, _
		  &h6b2395e0, &h333e92e1, &h3b240b62, &heebeb922, _
		  &h85b2a20e, &he6ba0d99, &hde720c8c, &h2da2f728, _
		  &hd0127845, &h95b794fd, &h647d0862, &he7ccf5f0, _
		  &h5449a36f, &h877d48fa, &hc39dfd27, &hf33e8d1e, _
		  &h0a476341, &h992eff74, &h3a6f6eab, &hf4f8fd37, _
		  &ha812dc60, &ha1ebddf8, &h991be14c, &hdb6e6b0d, _
		  &hc67b5510, &h6d672c37, &h2765d43b, &hdcd0e804, _
		  &hf1290dc7, &hcc00ffa3, &hb5390f92, &h690fed0b, _
		  &h667b9ffb, &hcedb7d9c, &ha091cf0b, &hd9155ea3, _
		  &hbb132f88, &h515bad24, &h7b9479bf, &h763bd6eb, _
		  &h37392eb3, &hcc115979, &h8026e297, &hf42e312d, _
		  &h6842ada7, &hc66a2b3b, &h12754ccc, &h782ef11c, _
		  &h6a124237, &hb79251e7, &h06a1bbe6, &h4bfb6350, _
		  &h1a6b1018, &h11caedfa, &h3d25bdd8, &he2e1c3c9, _
		  &h44421659, &h0a121386, &hd90cec6e, &hd5abea2a, _
		  &h64af674e, &hda86a85f, &hbebfe988, &h64e4c3fe, _
		  &h9dbc8057, &hf0f7c086, &h60787bf8, &h6003604d, _
		  &hd1fd8346, &hf6381fb0, &h7745ae04, &hd736fccc, _
		  &h83426b33, &hf01eab71, &hb0804187, &h3c005e5f, _
		  &h77a057be, &hbde8ae24, &h55464299, &hbf582e61, _
		  &h4e58f48f, &hf2ddfda2, &hf474ef38, &h8789bdc2, _
		  &h5366f9c3, &hc8b38e74, &hb475f255, &h46fcd9b9, _
		  &h7aeb2661, &h8b1ddf84, &h846a0e79, &h915f95e2, _
		  &h466e598e, &h20b45770, &h8cd55591, &hc902de4c, _
		  &hb90bace1, &hbb8205d0, &h11a86248, &h7574a99e, _
		  &hb77f19b6, &he0a9dc09, &h662d09a1, &hc4324633, _
		  &he85a1f02, &h09f0be8c, &h4a99a025, &h1d6efe10, _
		  &h1ab93d1d, &h0ba5a4df, &ha186f20f, &h2868f169, _
		  &hdcb7da83, &h573906fe, &ha1e2ce9b, &h4fcd7f52, _
		  &h50115e01, &ha70683fa, &ha002b5c4, &h0de6d027, _
		  &h9af88c27, &h773f8641, &hc3604c06, &h61a806b5, _
		  &hf0177a28, &hc0f586e0, &h006058aa, &h30dc7d62, _
		  &h11e69ed7, &h2338ea63, &h53c2dd94, &hc2c21634, _
		  &hbbcbee56, &h90bcb6de, &hebfc7da1, &hce591d76, _
		  &h6f05e409, &h4b7c0188, &h39720a3d, &h7c927c24, _
		  &h86e3725f, &h724d9db9, &h1ac15bb4, &hd39eb8fc, _
		  &hed545578, &h08fca5b5, &hd83d7cd3, &h4dad0fc4, _
		  &h1e50ef5e, &hb161e6f8, &ha28514d9, &h6c51133c, _
		  &h6fd5c7e7, &h56e14ec4, &h362abfce, &hddc6c837, _
		  &hd79a3234, &h92638212, &h670efa8e, &h406000e0 _
		  )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function S3() As UInt32()
		  return Array( _
		  &h3a39ce37, &hd3faf5cf, &habc27737, &h5ac52d1b, _
		  &h5cb0679e, &h4fa33742, &hd3822740, &h99bc9bbe, _
		  &hd5118e9d, &hbf0f7315, &hd62d1c7e, &hc700c47b, _
		  &hb78c1b6b, &h21a19045, &hb26eb1be, &h6a366eb4, _
		  &h5748ab2f, &hbc946e79, &hc6a376d2, &h6549c2c8, _
		  &h530ff8ee, &h468dde7d, &hd5730a1d, &h4cd04dc6, _
		  &h2939bbdb, &ha9ba4650, &hac9526e8, &hbe5ee304, _
		  &ha1fad5f0, &h6a2d519a, &h63ef8ce2, &h9a86ee22, _
		  &hc089c2b8, &h43242ef6, &ha51e03aa, &h9cf2d0a4, _
		  &h83c061ba, &h9be96a4d, &h8fe51550, &hba645bd6, _
		  &h2826a2f9, &ha73a3ae1, &h4ba99586, &hef5562e9, _
		  &hc72fefd3, &hf752f7da, &h3f046f69, &h77fa0a59, _
		  &h80e4a915, &h87b08601, &h9b09e6ad, &h3b3ee593, _
		  &he990fd5a, &h9e34d797, &h2cf0b7d9, &h022b8b51, _
		  &h96d5ac3a, &h017da67d, &hd1cf3ed6, &h7c7d2d28, _
		  &h1f9f25cf, &hadf2b89b, &h5ad6b472, &h5a88f54c, _
		  &he029ac71, &he019a5e6, &h47b0acfd, &hed93fa9b, _
		  &he8d3c48d, &h283b57cc, &hf8d56629, &h79132e28, _
		  &h785f0191, &hed756055, &hf7960e44, &he3d35e8c, _
		  &h15056dd4, &h88f46dba, &h03a16125, &h0564f0bd, _
		  &hc3eb9e15, &h3c9057a2, &h97271aec, &ha93a072a, _
		  &h1b3f6d9b, &h1e6321f5, &hf59c66fb, &h26dcf319, _
		  &h7533d928, &hb155fdf5, &h03563482, &h8aba3cbb, _
		  &h28517711, &hc20ad9f8, &habcc5167, &hccad925f, _
		  &h4de81751, &h3830dc8e, &h379d5862, &h9320f991, _
		  &hea7a90c2, &hfb3e7bce, &h5121ce64, &h774fbe32, _
		  &ha8b6e37e, &hc3293d46, &h48de5369, &h6413e680, _
		  &ha2ae0810, &hdd6db224, &h69852dfd, &h09072166, _
		  &hb39a460a, &h6445c0dd, &h586cdecf, &h1c20c8ae, _
		  &h5bbef7dd, &h1b588d40, &hccd2017f, &h6bb4e3bb, _
		  &hdda26a7e, &h3a59ff45, &h3e350a44, &hbcb4cdd5, _
		  &h72eacea8, &hfa6484bb, &h8d6612ae, &hbf3c6f47, _
		  &hd29be463, &h542f5d9e, &haec2771b, &hf64e6370, _
		  &h740e0d8d, &he75b1357, &hf8721671, &haf537d5d, _
		  &h4040cb08, &h4eb4e2cc, &h34d2466a, &h0115af84, _
		  &he1b00428, &h95983a1d, &h06b89fb4, &hce6ea048, _
		  &h6f3f3b82, &h3520ab82, &h011a1d4b, &h277227f8, _
		  &h611560b1, &he7933fdc, &hbb3a792b, &h344525bd, _
		  &ha08839e1, &h51ce794b, &h2f32c9b7, &ha01fbac9, _
		  &he01cc87e, &hbcc7d1f6, &hcf0111c3, &ha1e8aac7, _
		  &h1a908749, &hd44fbd9a, &hd0dadecb, &hd50ada38, _
		  &h0339c32a, &hc6913667, &h8df9317c, &he0b12b4f, _
		  &hf79e59b7, &h43f5bb3a, &hf2d519ff, &h27d9459c, _
		  &hbf97222c, &h15e6fc2a, &h0f91fc71, &h9b941525, _
		  &hfae59361, &hceb69ceb, &hc2a86459, &h12baa8d1, _
		  &hb6c1075e, &he3056a0c, &h10d25065, &hcb03a442, _
		  &he0ec6e0e, &h1698db3b, &h4c98a0be, &h3278e964, _
		  &h9f1f9532, &he0d392df, &hd3a0342b, &h8971f21e, _
		  &h1b0a7441, &h4ba3348c, &hc5be7120, &hc37632d8, _
		  &hdf359f8d, &h9b992f2e, &he60b6f47, &h0fe3f11d, _
		  &he54cda54, &h1edad891, &hce6279cf, &hcd3e7e6f, _
		  &h1618b166, &hfd2c1d05, &h848fd2c5, &hf6fb2299, _
		  &hf523f357, &ha6327623, &h93a83531, &h56cccd02, _
		  &hacf08162, &h5a75ebb5, &h6e163697, &h88d273cc, _
		  &hde966292, &h81b949d0, &h4c50901b, &h71c65614, _
		  &he6c6c7bd, &h327a140a, &h45e1d006, &hc3f27b9a, _
		  &hc9aa53fd, &h62a80f00, &hbb25bfe2, &h35bdd2f6, _
		  &h71126905, &hb2040222, &hb6cbcf7c, &hcd769c2b, _
		  &h53113ec0, &h1640e3d3, &h38abbd60, &h2547adf0, _
		  &hba38209c, &hf746ce76, &h77afa1c5, &h20756060, _
		  &h85cbfe4e, &h8ae88dd8, &h7aaaf9b0, &h4cf9aa7e, _
		  &h1948c25c, &h02fb8a8c, &h01c36ae4, &hd6ebe1f9, _
		  &h90d4f869, &ha65cdea0, &h3f09252d, &hc208e69f, _
		  &hb74e6132, &hce77e25b, &h578fdfe3, &h3ac372e6 _
		  )
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		P() As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		S(3,255) As UInt32
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass