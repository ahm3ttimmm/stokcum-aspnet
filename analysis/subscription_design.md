Abonelik Sistemi - Yüksek Seviye Taslak (ASP.NET Web Forms - .NET Framework 4.7.2)

1) Tablolar

- subscription_plans
  - id INT PK IDENTITY
  - name NVARCHAR(100)
  - description NVARCHAR(500)
  - price DECIMAL(18,2)
  - interval NVARCHAR(20) -- 'monthly','yearly','free','trial'
  - trial_days INT NULL
  - created_at DATETIME

- user_subscriptions
  - id INT PK PK
  - user_id INT FK -> Users(uyeno)
  - plan_id INT FK -> subscription_plans(id)
  - status NVARCHAR(20) -- 'active','expired','cancelled','trial'
  - start_date DATETIME
  - current_period_end DATETIME
  - next_billing_date DATETIME NULL
  - created_at DATETIME

- payments
  - id INT PK IDENTITY
  - user_subscription_id INT FK -> user_subscriptions(id)
  - amount DECIMAL(18,2)
  - currency NVARCHAR(10)
  - transaction_id NVARCHAR(200)
  - status NVARCHAR(50)
  - payment_provider NVARCHAR(50) -- 'stripe','iyzico' etc.
  - created_at DATETIME

2) Akış
- Kullanıcı bir plan seçer; kullanıcıya test/sunucu tarafı doğrulama yapılır.
- Ödeme istekleri için payment provider (Stripe veya Iyzico) entegrasyonuna hazır bir arayüz oluşturulur.
- Ödeme başarılı ise payments tablosuna kayıt ve user_subscriptions oluşturulur/ güncellenir.
- Cron veya arka plan job ile aboneliklerin süresi kontrol edilir; süresi dolanlar 'expired' olur.

3) Erişim Kısıtlama
- Web Forms için Global.asax Application_BeginRequest veya Page_Load içinde bir kontrol fonksiyonu çağırılabilir.
- Alternatif olarak base Page sınıfı (BasePage) oluşturup her sayfa bu sınıftan türetilebilir; BasePage.OnInit içinde subscription kontrolü yapılır.

4) Güvenlik ve Öneriler
- Ödeme anahtarları ve hassas bilgiler Web.config'de değil güvenli secret store'da tutulmalı.
- Ödeme webhook'larını doğrulayın (signature check).
- Kullanıcı abonelik durumu cache'lenebilir, fakat her kritik işlemde veritabanı ile doğrulama yapın.

5) Migration
- SQL script veya EF Code First Migrations oluşturulmalı.

