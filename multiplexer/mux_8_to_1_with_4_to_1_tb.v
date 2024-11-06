module mux_8_to_1_with_4_to_1_tb;

	reg d0, d1, d2, d3, d4, d5, d6, d7;
	reg s0, s1, s2;
	wire y;

	mux_8_to_1_with_4_to_1 uut (
		.d0(d0), .d1(d1), .d2(d2), .d3(d3),
		.d4(d4), .d5(d5), .d6(d6), .d7(d7),
		.s0(s0), .s1(s1), .s2(s2),
		.y(y)
	);

	
	initial begin
		// Inisialisasi semua input ke 0
		{d0, d1, d2, d3, d4, d5, d6, d7, s0, s1, s2} = 0;

		// Tes berbagai kombinasi input dan sinyal seleksi
		#10; d0 = 1; s0 = 0; s1 = 0; s2 = 0; 		  // Pilih d0, output y harus 1
		#10; d0 = 0; d1 = 1; s0 = 1; s1 = 0; s2 = 0; // Pilih d1, output y harus 1
		#10; d1 = 0; d2 = 1; s0 = 0; s1 = 1; s2 = 0; // Pilih d2, output y harus 1
		#10; d2 = 0; d3 = 1; s0 = 1; s1 = 1; s2 = 0; // Pilih d3, output y harus 1
		
		#10; d3 = 0; d4 = 1; s0 = 0; s1 = 0; s2 = 1; // Pilih d4, output y harus 1
		#10; d4 = 0; d5 = 1; s0 = 1; s1 = 0; s2 = 1; // Pilih d5, output y harus 1
		#10; d5 = 0; d6 = 1; s0 = 0; s1 = 1; s2 = 1; // Pilih d6, output y harus 1
		#10; d6 = 0; d7 = 1; s0 = 1; s1 = 1; s2 = 1; // Pilih d7, output y harus 1

		#10;
	end

endmodule 