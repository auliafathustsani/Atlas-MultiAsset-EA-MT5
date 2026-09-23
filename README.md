# Atlas Multi-Asset EA for MetaTrader 5

Atlas Multi-Asset EA merupakan Expert Advisor (EA) yang dikembangkan menggunakan bahasa MQL5 untuk platform MetaTrader 5. EA menerapkan strategi mengikuti tren dengan menggabungkan indikator Exponential Moving Average (EMA), Average Directional Index (ADX), Relative Strength Index (RSI), dan Average True Range (ATR).

Sistem dilengkapi dengan pengelolaan risiko berbasis persentase ekuitas, stop-loss dan take-profit, break-even, trailing stop, pembatas transaksi harian, serta perlindungan terhadap drawdown. EA tidak menggunakan martingale, grid, averaging, maupun high-frequency trading.

## Fitur Utama

* Penentuan arah tren menggunakan EMA cepat dan EMA lambat.
* Konfirmasi kekuatan tren menggunakan ADX.
* Konfirmasi momentum menggunakan RSI.
* Stop-loss berdasarkan nilai ATR.
* Take-profit berdasarkan rasio risiko.
* Perhitungan volume transaksi secara fixed fractional.
* Fitur break-even dan ATR trailing stop.
* Pembatasan spread dan waktu perdagangan.
* Batas jumlah transaksi harian.
* Batas kerugian harian.
* Perlindungan terhadap maximum equity drawdown.
* Satu posisi aktif pada setiap simbol.
* Mendukung pengujian pada beberapa kelas aset.

## Struktur Proyek

```text
Atlas-MultiAsset-EA-MT5/
├── MQL5/
│   ├── Experts/
│   │   └── AtlasMultiAssetEA.mq5
│   └── Include/
│       └── Atlas/
│           ├── RiskManager.mqh
│           └── TradeGuards.mqh
├── Presets/
├── Config/
│   └── instruments.csv
├── Reports/
│   ├── screenshots/
│   ├── LAPORAN_PROYEK.md
│   ├── BACKTEST_RESULTS.csv
│   ├── OPTIMIZATION_PROTOCOL.md
│   └── TEST_CHECKLIST.md
├── Scripts/
│   └── score_optimization.py
├── PROJECT_STATUS.md
├── LICENSE
└── README.md
```

## Daftar Instrumen

EA dirancang agar dapat digunakan pada sepuluh instrumen yang berasal dari beberapa kelas aset. Pada tahap ini, pengujian aktual baru dilakukan pada EURUSD dan USDJPY.

| No. | Instrumen | Kelas Aset | Status      |
| --: | --------- | ---------- | ----------- |
|   1 | EURUSD    | Forex      | Sudah diuji |
|   2 | USDJPY    | Forex      | Sudah diuji |
|   3 | XAUUSD    | Logam      | Belum diuji |
|   4 | XAGUSD    | Logam      | Belum diuji |
|   5 | JP225     | Indeks     | Belum diuji |
|   6 | US500     | Indeks     | Belum diuji |
|   7 | BTCUSD    | Kripto     | Belum diuji |
|   8 | ETHUSD    | Kripto     | Belum diuji |
|   9 | UKOIL     | Energi     | Belum diuji |
|  10 | USOIL     | Energi     | Belum diuji |

Nama simbol dapat berbeda pada setiap broker. Nama atau suffix simbol perlu disesuaikan dengan simbol yang tersedia pada Market Watch.

## Konfigurasi Pengujian

Pengujian EURUSD dan USDJPY dilakukan menggunakan konfigurasi berikut:

* Platform: MetaTrader 5
* Expert Advisor: AtlasMultiAssetEA
* Timeframe: H1
* Periode: 23 September 2019–8 September 2026
* Deposit awal: USD 10.000
* Model pengujian: Every tick based on real ticks
* History quality: 100%
* Metode optimasi: Fast genetic based algorithm
* Kriteria optimasi: Complex Criterion max
* Terminal pengujian: MetaQuotes-Demo

Optimasi awal dilakukan menggunakan model 1 minute OHLC untuk mempercepat pencarian parameter. Kandidat parameter yang dipilih kemudian diuji kembali menggunakan Every tick based on real ticks pada seluruh periode pengujian.

## Parameter Hasil Optimasi

### EURUSD H1

| Parameter         | Nilai |
| ----------------- | ----: |
| Fast EMA          |    60 |
| Slow EMA          |   100 |
| Minimum ADX       |    20 |
| Minimum RSI long  |    56 |
| Maximum RSI short |    48 |

### USDJPY H1

| Parameter         | Nilai |
| ----------------- | ----: |
| Fast EMA          |    30 |
| Slow EMA          |   220 |
| Minimum ADX       |    15 |
| Minimum RSI long  |    52 |
| Maximum RSI short |    44 |

## Hasil Backtest

| Instrumen | Net Profit | Return | Profit Factor | Max. Equity DD | Sharpe Ratio | Total Transaksi |
| --------- | ---------: | -----: | ------------: | -------------: | -----------: | --------------: |
| EURUSD H1 | USD 247,08 |  2,47% |          1,02 |         10,02% |         0,10 |             474 |
| USDJPY H1 | USD 990,36 |  9,90% |          1,09 |         11,72% |         0,39 |             534 |

Hasil pengujian menunjukkan bahwa kedua instrumen menghasilkan net profit positif dan memiliki maximum equity drawdown di bawah 30%. USDJPY memberikan hasil yang lebih baik dibandingkan EURUSD berdasarkan net profit, profit factor, recovery factor, dan Sharpe ratio.

Meskipun demikian, profit factor kedua instrumen masih mendekati 1 sehingga keunggulan strategi belum kuat. Return yang diperoleh juga belum memenuhi sasaran 3–5% per bulan atau 50–70% per tahun. Hasil tersebut harus dipahami sebagai hasil historis pada lingkungan pengujian yang digunakan, bukan sebagai jaminan keuntungan.

## Cara Instalasi

1. Buka MetaTrader 5.
2. Pilih `File > Open Data Folder`.
3. Salin `AtlasMultiAssetEA.mq5` ke folder `MQL5/Experts`.
4. Salin folder `Atlas` ke folder `MQL5/Include`.
5. Buka `AtlasMultiAssetEA.mq5` melalui MetaEditor.
6. Tekan `F7` untuk melakukan kompilasi.
7. Pastikan hasil kompilasi menunjukkan `0 errors, 0 warnings`.
8. Buka Strategy Tester pada MetaTrader 5.
9. Pilih `AtlasMultiAssetEA.ex5`.
10. Tentukan simbol, timeframe, periode, dan model pengujian.
11. Jalankan backtest atau optimasi.

## Kesimpulan

Atlas Multi-Asset EA berhasil dikembangkan dan dikompilasi dengan hasil 0 error dan 0 warning. EA telah menerapkan sistem sinyal, pengelolaan posisi, dan perlindungan risiko tanpa menggunakan martingale, grid, averaging, maupun HFT.

Validasi aktual baru dilakukan pada EURUSD dan USDJPY. Keduanya menghasilkan keuntungan positif dengan drawdown di bawah batas 30%, tetapi belum mencapai sasaran return yang ditentukan. Oleh karena itu, EA dinyatakan berhasil dari sisi implementasi teknis, tetapi masih memerlukan pengembangan dan pengujian lebih lanjut sebelum digunakan pada akun riil.

## Catatan Risiko

Proyek ini dibuat untuk keperluan pengembangan dan penelitian. Hasil backtest tidak menjamin kinerja yang sama pada masa mendatang. Perbedaan broker, spread, komisi, swap, slippage, spesifikasi kontrak, dan kualitas data dapat memengaruhi hasil pengujian.

Pengujian saat ini dilakukan pada MetaQuotes-Demo. Pengujian ulang menggunakan data dan spesifikasi simbol dari broker yang akan digunakan tetap diperlukan sebelum EA diterapkan pada akun riil.
