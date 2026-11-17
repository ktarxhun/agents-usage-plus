# Ajan Limitleri

Claude Code, Codex ve Antigravity kalan limitlerini KDE Plasma 6 tepsisinde gösterir.
Popup'ta her sağlayıcının 5 saatlik ve haftalık limitleri ayrı çubuklarla görünür.

Bu proje, [yusufipk/kde-agents-usage](https://github.com/yusufipk/kde-agents-usage) (MIT)
temel alınarak geliştirildi. Bu sürümde eklenenler:

- **Antigravity** sağlayıcısı: Gemini ve Claude/GPT model grupları için 5 saatlik ve haftalık
  limit, bir de Gemini 4 Argon haftalık limiti. Veri çalışan Antigravity sunucusundan okunur.
- **Haftalık bittiğinde 5 saatlik de %100 gösterilir** (haftalık dolu iken 5 saatlik kullanılamaz).
- **Ayarlar:** yenileme süresi, sağlayıcı ve pencere bazında göster/gizle, Tokenlar sekmesini
  gizle, son güncelleme satırını gizle, tepsi ikonunu halka ya da düz ikon yap.
- Plan etiketi (Pro, Plus) yuvarlak rozet yerine düz metin.

Antigravity parser'ı gerçek hesapla doğrulanmadı. Ham yanıtı görmek için:

```bash
python3 -I ~/.local/share/plasma/plasmoids/io.github.kuzey.agentsusage/contents/code/fetch_usage.py --dump-antigravity
```

Kurulum: `cd agents-usage-plus && sh install.sh`, sonra tepsi ayarlarında "Ajan Limitleri"ni göster.

## Temel alınan çalışma

Bu proje [Yusuf İpek](https://github.com/yusufipk)'in [kde-agents-usage](https://github.com/yusufipk/kde-agents-usage)
widget'ı üzerine kuruldu (MIT). Orijinal telif notu LICENSE dosyasında korunuyor.

