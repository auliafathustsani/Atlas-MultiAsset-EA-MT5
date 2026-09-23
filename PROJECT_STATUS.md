# Status Proyek

## Selesai

- Source code EA MQL5 modular.
- Kompilasi MetaEditor berhasil: 0 error dan 0 warning.
- Fixed-fractional risk sizing berdasarkan nilai rugi aktual satu lot.
- EMA, ADX, RSI, dan ATR signal engine.
- Stop-loss, take-profit, break-even, ATR trailing, dan time exit.
- Daily loss guard, maximum equity drawdown circuit breaker, spread guard, session guard, serta batas trade harian.
- Sepuluh preset awal lintas lima kelas aset.
- Protokol backtest, optimasi, forward validation, dan stress test.
- Template laporan dan rekap hasil.
- Skrip pemeringkat kandidat optimasi.
- Backtest dan optimasi awal EURUSD H1 pada terminal MetaQuotes-Demo.

## Menunggu lingkungan pengguna

- Pemindahan pengujian dari MetaQuotes-Demo ke terminal Exness sesuai ketentuan tugas.
- Verifikasi nama/suffix simbol Exness.
- Pengunduhan history real ticks pada terminal Exness.
- Backtest, optimasi, dan validasi tujuh tahun untuk sembilan instrumen lainnya.
- Ekspor report HTML/XML dan pengisian laporan akhir dengan seluruh hasil asli.

## Hasil sementara

EURUSD H1 telah divalidasi pada periode 23 September 2019–8 September 2026 menggunakan `Every tick based on real ticks`. Hasil sementara menunjukkan net profit USD 247,08 (2,47%), profit factor 1,02, maximum equity drawdown 10,02%, Sharpe ratio 0,10, dan 474 transaksi. Hasil ini positif tetapi belum memenuhi target tugas, serta belum dapat disebut hasil Exness karena pengujian dilakukan pada MetaQuotes-Demo.

## Alasan tahap ini tidak dapat dipalsukan

Hasil Strategy Tester bergantung pada server, jenis akun, contract specification, spread, komisi, swap, ketersediaan tick, versi terminal, dan tanggal pengujian. Karena lingkungan tersebut berada pada terminal pengguna, tabel hasil sengaja berstatus `PENDING` hingga pengujian dijalankan.
