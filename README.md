# Atlas Multi-Asset EA for MetaTrader 5

Atlas EA adalah proyek Expert Advisor (EA) multi-aset untuk MT5/MQL5. Strategi menggunakan konfirmasi tren dan momentum, stop-loss/take-profit berbasis ATR, serta pengelolaan risiko fixed-fractional. EA tidak menggunakan martingale, grid, averaging, atau high-frequency trading.

## Status hasil

Kode dan konfigurasi disediakan sebagai proyek siap kompilasi dan siap diuji. Angka return, drawdown, dan kestabilan bulanan hanya dapat dinyatakan setelah Strategy Tester MT5 menjalankan data real tick dari Exness. Target 3–5% per bulan, 50–70% per tahun, drawdown maksimum 25–30%, dan maksimal enam bulan rugi per tahun adalah kriteria seleksi optimasi, bukan jaminan kinerja.

Kompilasi saat ini berhasil dengan 0 error dan 0 warning. Pengujian sementara EURUSD H1 pada MetaQuotes-Demo menghasilkan net profit 2,47%, profit factor 1,02, dan maximum equity drawdown 10,02% selama periode 23 September 2019–8 September 2026. Hasil tersebut belum memenuhi target tugas dan harus diuji ulang menggunakan data/simbol Exness.

## Isi proyek

- `MQL5/Experts/AtlasMultiAssetEA.mq5`: kode utama EA.
- `MQL5/Include/Atlas/RiskManager.mqh`: kalkulasi volume dan normalisasi harga.
- `MQL5/Include/Atlas/TradeGuards.mqh`: pemeriksaan spread, sesi, dan bar baru.
- `Presets/`: preset awal untuk 10 kelompok instrumen.
- `Config/instruments.csv`: pemetaan simbol dan kelas aset.
- `Scripts/score_optimization.py`: penyaring hasil optimasi CSV.
- `Reports/`: protokol uji, format pencatatan, dan template laporan.

## Instalasi

1. Buka MT5, lalu pilih `File > Open Data Folder`.
2. Salin isi folder `MQL5` proyek ini ke folder `MQL5` milik terminal.
3. Buka `AtlasMultiAssetEA.mq5` melalui MetaEditor dan tekan `F7`.
4. Pastikan tidak ada error kompilasi.
5. Buka Strategy Tester, pilih EA, simbol, timeframe, periode, dan preset `.set`.

## Ketentuan backtest utama

- Model: `Every tick based on real ticks`.
- Periode: tujuh tahun penuh dan berakhir pada tanggal pengujian.
- Broker/data: terminal Exness milik pengguna.
- Forward test: 20% periode atau minimal 12 bulan terakhir.
- Deposit awal dan mata uang harus sama untuk semua instrumen.
- Satu instrumen diuji per run agar hasil dapat diaudit.
- Akun real hanya dipakai sebagai sumber lingkungan/simbol jika memang diwajibkan; jangan mengaktifkan AutoTrading pada akun real untuk pengujian.

## Instrumen contoh

Nama simbol berbeda menurut tipe akun/server Exness. Gunakan simbol yang tersedia pada Market Watch dan sesuaikan `Config/instruments.csv` bila terdapat suffix.

1. EURUSD
2. USDJPY
3. XAUUSD
4. XAGUSD
5. JP225
6. US500
7. BTCUSD
8. ETHUSD
9. UKOIL
10. USOIL

## Cara optimasi

Gunakan rentang pada `Reports/OPTIMIZATION_PROTOCOL.md`. Jalankan genetic optimization pada data in-sample, lalu verifikasi kandidat terbaik pada forward period dan full seven-year backtest. Ekspor hasil optimasi menjadi XML/CSV. Skrip skor hanya membantu menyaring kandidat; keputusan akhir harus mempertimbangkan equity curve dan stabilitas out-of-sample.

Contoh:

```bash
python Scripts/score_optimization.py hasil_optimasi.csv kandidat_terbaik.csv
```

## Peringatan

EA ini merupakan perangkat penelitian dan bukan janji keuntungan. Hasil historis tidak menjamin hasil masa depan. Jangan menyimpan login, password, investor password, OTP, atau API key di repository.
