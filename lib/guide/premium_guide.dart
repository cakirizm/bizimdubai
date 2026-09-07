part of '../main.dart';

const _guideRed = Color(0xFFE30613);
const _guideInk = Color(0xFF15171B);
const _guideMuted = Color(0xFF6F7782);

class GuideLink {
  const GuideLink(this.label, this.url, {this.note = '', this.official = true});
  final String label, url, note;
  final bool official;
}

class GuidePlace {
  const GuidePlace(this.name, this.area, this.query, {this.note = ''});
  final String name, area, query, note;
}

class GuideArticle {
  const GuideArticle({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.order,
    required this.steps,
    required this.checklist,
    required this.links,
    this.places = const [],
    this.tips = const [],
    this.warning,
    this.featured = false,
  });
  final String id, category, title, subtitle;
  final IconData icon;
  final int order;
  final List<String> steps, checklist, tips;
  final List<GuideLink> links;
  final List<GuidePlace> places;
  final String? warning;
  final bool featured;
}

const guideCategories = <(String, IconData)>[
  ('Yeni Geldim', Icons.flight_land_rounded),
  ('Kimlik & Resmî', Icons.badge_outlined),
  ('Ev & Yaşam', Icons.home_work_outlined),
  ('Banka & Para', Icons.account_balance_outlined),
  ('Araç & Ulaşım', Icons.directions_car_filled_outlined),
  ('Sağlık', Icons.health_and_safety_outlined),
  ('Aile & Eğitim', Icons.family_restroom_outlined),
  ('İş & Kariyer', Icons.work_outline_rounded),
  ('Ayrılış', Icons.flight_takeoff_rounded),
];

const guideArticles = <GuideArticle>[
  GuideArticle(
    id: 'first-72-hours', category: 'Yeni Geldim', title: 'Dubai’ye yeni geldim: ilk 72 saat',
    subtitle: 'Telefon → oturum/ID → UAE Pass → banka → ev → ulaşım sırasını karıştırma.',
    icon: Icons.route_rounded, order: 1, featured: true,
    steps: [
      'Önce çalışan bir UAE telefon hattı edin. OTP, banka ve devlet uygulamalarında buna ihtiyacın olacak.',
      'Oturum sürecini sponsorun/işverenin ile kontrol et; Emirates ID başvurusu ve biyometri durumunu ICP/GDRFA üzerinden takip et.',
      'Emirates ID aktif olduğunda UAE Pass hesabını doğrula. Birçok Dubai hizmetinde tek giriş noktası olur.',
      'Maaş hesabı gerekiyorsa Emirates ID + pasaport + gelir/iş belgenle bankaları karşılaştır.',
      'Kalıcı ev için kontratı imzalamadan önce taşınma bütçesine depozito, emlak komisyonu, Ejari ve DEWA güvence bedelini ekle.',
      'Ejari tamamlandıktan sonra DEWA Move-in akışını tamamla. Çoğu normal kiralamada Ejari bilgisi DEWA’ya entegre aktarılır.',
      'Günlük ulaşım için nol kart edin; araç kullanacaksan ehliyet değişim uygunluğunu ayrıca kontrol et.',
    ],
    checklist: ['Pasaport', 'Residence visa / oturum bilgisi', 'UAE mobil numarası', 'Emirates ID veya başvuru durumu', 'İş sözleşmesi / salary certificate', 'Konaklama adresi'],
    links: [
      GuideLink('ICP – Emirates ID ve kimlik hizmetleri', 'https://icp.gov.ae/en/services/'),
      GuideLink('GDRFA Dubai – oturum hizmetleri', 'https://www.gdrfad.gov.ae/en'),
      GuideLink('UAE Pass', 'https://uaepass.ae/'),
      GuideLink('DubaiNow', 'https://www.digitaldubai.ae/apps-services/details/dubainow'),
    ],
    tips: ['Kısa süreli oteldeysen banka ve bazı KYC işlemleri için kalıcı adres istenebileceğini hesaba kat.', 'Her ödeme makbuzunu ve kontrat PDF’ini ayrı klasörde sakla.'],
  ),
  GuideArticle(
    id: 'sim', category: 'Yeni Geldim', title: 'SIM / eSIM: du, e&, Virgin Mobile',
    subtitle: 'Turist hattından resident hatta geçiş, mağaza ve online seçenekler.',
    icon: Icons.sim_card_outlined, order: 2, featured: true,
    steps: [
      'Kısa süreli girişte turist SIM/eSIM paketlerinden birini seç. Pasaport doğrulaması gerekir.',
      'Oturum/Emirates ID çıktıktan sonra numaranı resident/prepaid/postpaid plana taşımak veya yeni resident hat açmak için operatörün kimlik doğrulamasını tamamla.',
      'Bankacılık ve UAE Pass için uzun süre kullanacağın tek ana numarayı seç; sürekli numara değiştirmek OTP ve KYC süreçlerini zorlaştırır.',
      'Planı seçerken yalnız GB’ye değil, yerel dakika, uluslararası dakika, sözleşme süresi ve erken çıkış koşullarına bak.',
    ],
    checklist: ['Pasaport', 'Giriş/visa bilgisi', 'Resident plan için Emirates ID', 'eSIM destekli cihaz varsa EID/IMEI bilgileri'],
    links: [
      GuideLink('du – Tourist SIM/eSIM', 'https://www.du.ae/personal/mobile/prepaid-plans/tourist-sim/registration'),
      GuideLink('e& UAE – Mobile', 'https://www.eand.com/en/c/mobile.html'),
      GuideLink('Virgin Mobile UAE', 'https://www.virginmobile.ae/'),
    ],
    places: [
      GuidePlace('du mağazaları', 'Dubai genelinde', 'du store Dubai', note: 'En yakın mağazayı haritada aç.'),
      GuidePlace('e& mağazaları', 'Dubai genelinde', 'e& store Dubai', note: 'Emirates ID güncellemesi için de kullanılabilir.'),
      GuidePlace('Virgin Mobile kiosk/mağaza', 'Dubai genelinde', 'Virgin Mobile UAE store Dubai'),
    ],
    tips: ['Turist plan fiyatı ile resident plan fiyatını karıştırma; geçerlilik süresi farklıdır.', 'Numara taşıma yapacaksan mevcut hattı iptal etmeden önce port sürecini başlat.'],
  ),
  GuideArticle(
    id: 'emirates-id', category: 'Kimlik & Resmî', title: 'Emirates ID & oturum takibi',
    subtitle: 'Kimlik başvurusu, durum kontrolü ve hangi kurumun ne yaptığı.',
    icon: Icons.badge_rounded, order: 3, featured: true,
    steps: [
      'Dubai residence sürecini sponsor/işveren veya yetkili kanal üzerinden başlat.',
      'Emirates ID başvuru numaranı sakla. ICP üzerinden kimlik durumunu takip et.',
      'Biyometri randevusu istenirse verilen merkeze pasaport ve başvuru bilgilerinle git.',
      'Kart/kimlik aktif olduktan sonra banka, operatör ve diğer KYC kayıtlarında kimlik bilgilerini güncelle.',
    ],
    checklist: ['Pasaport', 'Residence/entry permit bilgisi', 'Başvuru numarası', 'Biyometri randevusu varsa randevu bilgisi'],
    links: [
      GuideLink('ICP – ID Card', 'https://icp.gov.ae/en/id-card/'),
      GuideLink('ICP – hizmetler', 'https://icp.gov.ae/en/services/'),
      GuideLink('GDRFA Dubai', 'https://www.gdrfad.gov.ae/en'),
    ],
    places: [GuidePlace('ICP / Emirates ID service centre', 'Dubai', 'ICP Emirates ID service center Dubai'), GuidePlace('Amer Center', 'Dubai', 'Amer Center Dubai')],
    tips: ['Dubai oturumu ile federal Emirates ID süreçleri farklı kurum ekranlarında görünebilir; başvuru referansını kaybetme.'],
  ),
  GuideArticle(
    id: 'uae-pass', category: 'Kimlik & Resmî', title: 'UAE Pass & DubaiNow kurulumu',
    subtitle: 'Devlet hizmetlerine tek giriş için temel dijital kimlik.',
    icon: Icons.verified_user_outlined, order: 4,
    steps: ['UAE Pass uygulamasını indir ve UAE mobil numaranla hesabı başlat.', 'Emirates ID ve kimlik doğrulama adımlarını tamamla.', 'Dijital imza/kimlik seviyesi istenen hizmetlerde uygulamanın doğrulama yönlendirmesini takip et.', 'DubaiNow’u UAE Pass ile bağlayıp fatura, trafik ve kamu servislerini tek yerde kontrol et.'],
    checklist: ['Aktif UAE telefon numarası', 'Emirates ID', 'Telefonunda kamera/biometric erişimi'],
    links: [GuideLink('UAE Pass resmî site', 'https://uaepass.ae/'), GuideLink('DubaiNow', 'https://www.digitaldubai.ae/apps-services/details/dubainow')],
  ),
  GuideArticle(
    id: 'bank-account', category: 'Banka & Para', title: 'Banka hesabı açma: örnek bankalar',
    subtitle: 'Emirates NBD, ADCB ve hesap açmadan önce kontrol edeceğin gerçek kriterler.',
    icon: Icons.account_balance_rounded, order: 5, featured: true,
    steps: [
      'Emirates ID ve aktif UAE telefon numaran hazır olsun. Maaş hesabı açıyorsan salary certificate / sözleşme / payslip belgelerini de hazırla.',
      'Önce aylık minimum salary veya minimum balance şartını kontrol et; sadece “ücretsiz hesap” yazısına bakma.',
      'Emirates NBD Standard Current Account için expat kimlik belgeleri Emirates ID + pasaport; salary-transfer hesabında banka ek gelir/iş belgesi ister. Bankanın yayımladığı standard hesapta maaş transferi için AED 5,000 veya non-salaried müşteri için AED 3,000 minimum balance şartı belirtiliyor.',
      'ADCB Current Account UAE residents içindir; yayımlanan temel belgeler geçerli residence visa içeren pasaport, Emirates ID ve salary certificate. Sayfada minimum aylık salary AED 5,000 olarak gösteriliyor.',
      'KFS (Key Facts Statement) ve Schedule of Fees dosyasını açmadan başvuru yapma: minimum balance penalty, ATM, cheque, transfer ve erken kapanış ücretlerini kontrol et.',
    ],
    checklist: ['Original Emirates ID', 'Pasaport', 'Residence visa bilgisi', 'Salary certificate / iş sözleşmesi / payslip', 'UAE mobil numarası', 'Adres kanıtı istenirse Ejari/utility'],
    links: [
      GuideLink('Emirates NBD – Standard Current Account', 'https://www.emiratesnbd.com/en/accounts/current-accounts/standard-current-account'),
      GuideLink('Emirates NBD – hesap açma belgeleri', 'https://www.emiratesnbd.com/en/help-and-support/documents-to-open-an-account'),
      GuideLink('ADCB – Current Account', 'https://www.adcb.com/en/personal/accounts/current-savings-account/adcb-current-accounts'),
    ],
    places: [
      GuidePlace('Emirates NBD şubeleri', 'Dubai genelinde', 'Emirates NBD branch Dubai'),
      GuidePlace('ADCB şubeleri', 'Dubai genelinde', 'ADCB branch Dubai'),
    ],
    tips: ['Kredi kartı limiti ile banka hesabı uygunluğunu birbirine karıştırma.', 'Maaş bankası seçme hakkın yoksa bile ikinci bir kişisel hesap açıp açamayacağını karşılaştırabilirsin.'],
  ),
  GuideArticle(
    id: 'rent-home', category: 'Ev & Yaşam', title: 'Ev kiralama: doğru sıra',
    subtitle: 'Bölge seçimi → teklif → kontrat → Ejari → DEWA → internet → teslim.',
    icon: Icons.apartment_rounded, order: 6, featured: true,
    steps: [
      'Aylık kira yerine toplam giriş nakdini hesapla: kira çekleri, security deposit, komisyon, Ejari, DEWA deposit ve taşınma maliyeti.',
      'İlanı ve emlak aracısını doğrula; ödeme yapmadan önce landlord/agency belgelerini ve kontrat taraflarını kontrol et.',
      'Unified Tenancy Contract ve varsa addendum maddelerini satır satır oku; ödeme takvimi, bakım, erken çıkış, yenileme ve depozito şartlarını yazılı tut.',
      'Kontrat imzalandıktan sonra Ejari kaydını tamamla.',
      'Ejari sonrası DEWA Move-in ve ardından internet bağlantısı yap.',
      'Anahtar tesliminde sayaç, duvar, mobilya ve cihaz durumunu tarihli foto/video ile kaydet.',
    ],
    checklist: ['Pasaport/Emirates ID', 'Unified tenancy contract', 'Ödeme planı/cheque detayları', 'Landlord/agency bilgisi', 'Teslim fotoğrafları'],
    links: [GuideLink('Dubai Land Department', 'https://dubailand.gov.ae/en/'), GuideLink('DLD – Unified Ejari contract', 'https://dubailand.gov.ae/en/eservices/ejari-templates/download-unified-ejari-tenancy-contract/'), GuideLink('DLD – Rental Index', 'https://dubailand.gov.ae/en/eservices/rental-index/')],
    warning: 'BizimDubai hukuki karar vermez. Kontratta özel/uyuşmazlık doğurabilecek madde varsa resmi kurum veya yetkili profesyonelden destek al.',
  ),
  GuideArticle(
    id: 'ejari', category: 'Ev & Yaşam', title: 'Ejari: kayıt / yenileme',
    subtitle: 'Dubai REST, DLD ve Trustee Centre seçenekleri; ücret ve belge kontrolü.',
    icon: Icons.description_outlined, order: 7,
    steps: [
      'Dubai REST veya DLD/Ejari kanalından Register / Renew Tenancy Contract hizmetini aç.',
      'Uygulama üzerinden bireysel başvuruda unified tenancy contract kopyasını hazırla; trustee center işleminde original contract ve Emirates ID istenir.',
      'Bilgileri doldur, belgeleri yükle ve ücreti öde.',
      'Onay sonrası e-Contract Registration Certificate e-posta ile gelir; PDF’i sakla.',
      'DLD’nin güncel sayfasındaki ücreti başvuru anında tekrar kontrol et. 2026 sayfasında online/app toplamı AED 177.75, trustee center toplamı AED 220 olarak listeleniyor.',
    ],
    checklist: ['Unified tenancy contract', 'Emirates ID', 'Gerekirse POA', 'Landlord bilgilerinin güncel olması'],
    links: [GuideLink('DLD – Register / Renew Ejari', 'https://dubailand.gov.ae/en/eservices/register-renew-ejari-contract/'), GuideLink('DLD – Ejari certificate download', 'https://dubailand.gov.ae/en/eservices/download-ejari-certificate/'), GuideLink('DLD – Ejari FAQ', 'https://dubailand.gov.ae/en/frequently-asked-questions')],
    places: [GuidePlace('Real Estate Services Trustee', 'Dubai', 'Ejari Trustee Center Dubai', note: 'Fiziksel işlem gerekiyorsa en yakın yetkili merkezi bul.')],
  ),
  GuideArticle(
    id: 'dewa', category: 'Ev & Yaşam', title: 'DEWA Move-in: elektrik & su',
    subtitle: 'Ejari’den sonra elektrik ve suyu doğru sırayla aç.',
    icon: Icons.bolt_rounded, order: 8,
    steps: [
      'Kiracıysan geçerli Ejari numaranı hazırla. Normal Ejari akışında DLD entegrasyonu DEWA’ya yeni account bilgilerini otomatik aktarabilir.',
      'DEWA Move-in sayfası / app / DubaiNow üzerinden hesabı aç.',
      'Security deposit ve activation ücretlerini öde. DEWA’nın güncel servis rehberinde residential deposit flat için AED 2,000, villa için AED 4,000 olarak listeleniyor.',
      'DEWA, security deposit ödemesinden sonra bağlantının 15 working hours içinde yapılacağını belirtiyor.',
      'Welcome email, account number ve payment receipt’i sakla.',
    ],
    checklist: ['Ejari number (tenant)', 'Owner için title deed / SPA', 'DEWA premise bilgisi', 'Ödeme yöntemi'],
    links: [GuideLink('DEWA – Move-in', 'https://www.dewa.gov.ae/en/about-us/service-guide/consumer-services/move-in'), GuideLink('DEWA – consumer portal', 'https://www.dewa.gov.ae/en/consumer'), GuideLink('DEWA – Move-to', 'https://www.dewa.gov.ae/en/about-us/service-guide/consumer-services/move-to')],
    places: [GuidePlace('DEWA Customer Happiness Centre', 'Dubai', 'DEWA Customer Happiness Centre Dubai')],
    tips: ['Taşınıyorsan yeni hesap açmak yerine DEWA Move-to hizmetinin uygun olup olmadığını kontrol et.'],
  ),
  GuideArticle(
    id: 'home-internet', category: 'Ev & Yaşam', title: 'Ev interneti: du veya e&',
    subtitle: 'Binaya göre altyapı değişir; paket almadan adres uygunluğunu kontrol et.',
    icon: Icons.router_outlined, order: 9,
    steps: ['Önce binanın hangi operatör altyapısını desteklediğini kontrol et.', 'Contract period, installation, router, relocation ve early termination şartlarını karşılaştır.', 'Ejari/address ve Emirates ID bilgilerinin hazır olması işlemi hızlandırır.', 'Kurulum randevusundan sonra hız testini Wi‑Fi ve mümkünse Ethernet ile ayrı ayrı yap.'],
    checklist: ['Emirates ID', 'Adres/Ejari', 'UAE telefon numarası', 'Kurulum için evde erişim'],
    links: [GuideLink('du – Home', 'https://www.du.ae/personal/at-home'), GuideLink('e& UAE – Home', 'https://www.eand.com/en/c/home.html')],
    places: [GuidePlace('du store', 'Dubai', 'du store Dubai'), GuidePlace('e& store', 'Dubai', 'e& store Dubai')],
  ),
  GuideArticle(
    id: 'nol', category: 'Araç & Ulaşım', title: 'Metro, tram, bus: nol kart',
    subtitle: 'Dubai toplu taşımasının temel ödeme kartı.',
    icon: Icons.directions_subway_rounded, order: 10,
    steps: ['Günlük kullanım için nol Silver/uygun kart türünü seç; öğrenci/senior/POD isen Personal nol indirim uygunluğunu kontrol et.', 'Kartı metro ticket office, vending machine, authorised sales agent veya desteklenen dijital kanallardan edin.', 'Check-in öncesi yeterli balance bulundur. RTA, kullanım için minimum AED 7.50 balance gerektiğini belirtiyor.', 'Metro/bus/tram giriş ve çıkışta kartı okut; ücret zone sayısına göre hesaplanır.'],
    checklist: ['Anonim kart için temel satın alma; personal/concession kart için ilgili kimlik ve uygunluk belgeleri'],
    links: [GuideLink('RTA – About nol', 'https://www.rta.ae/wps/portal/rta/ae/public-transport/About-Nol-Card'), GuideLink('RTA – nol kart seç', 'https://rta.ae/wps/portal/rta/ae/public-transport/choosenolcard?lang=en'), GuideLink('RTA – nol nasıl alınır', 'https://www.rta.ae/wps/portal/rta/ae/public-transport/nol/nol-how')],
    places: [GuidePlace('Dubai Metro ticket office', 'Dubai', 'Dubai Metro ticket office'), GuidePlace('RTA Customer Happiness Centre', 'Dubai', 'RTA Customer Happiness Centre Dubai')],
  ),
  GuideArticle(
    id: 'driving-licence', category: 'Araç & Ulaşım', title: 'Türk ehliyetini Dubai ehliyetine çevirme',
    subtitle: 'Türkiye RTA’nın exchange listesinde; belge, göz testi ve ücret sırası.',
    icon: Icons.credit_card_rounded, order: 11, featured: true,
    steps: [
      'RTA’nın “Exchanging Licences” hizmetinde ülke olarak Turkey seç. 2026 RTA listesinde Türkiye, nationality’den bağımsız değiştirilebilir ülkeler arasında yer alıyor.',
      'Geçerli Emirates ID ve orijinal Türk sürücü belgeni hazırla.',
      'RTA accredited eye test yaptır. Sonuç elektronik olarak sisteme işlenir.',
      'Türkiye ehliyeti için RTA, konsolosluk/elçilikten Driving Licence Data Certificate ve bunun Ministry of Foreign Affairs tarafından tasdik edilmesini şart olarak belirtiyor.',
      'RTA online akışında UAE Pass / Emirates ID ile başvur, ücretleri öde ve istenen doğrulamaları tamamla.',
      'RTA’nın 25 Ağustos 2026 güncellenmiş sayfasında standart exchange toplam ücret örneği Traffic File 200 + Licence 600 + handbook 50 + eye test 180 + knowledge/innovation 20 = AED 1,050 olarak gösteriliyor; işlem öncesi canlı tutarı tekrar kontrol et.',
    ],
    checklist: ['Valid Emirates ID', 'Original Turkish driving licence', 'Electronic eye test', 'Turkish licence data certificate – consulate/embassy', 'MOFA attestation as required by RTA'],
    links: [GuideLink('RTA – Driving Licence Exchange', 'https://www.rta.ae/wps/portal/rta/ae/home/rta-services/service-details?serviceId=121'), GuideLink('RTA – ana site', 'https://www.rta.ae/')],
    places: [GuidePlace('RTA Customer Happiness Centre – Al Barsha', 'Al Barsha', 'RTA Customer Happiness Centre Al Barsha Dubai'), GuidePlace('RTA Customer Happiness Centre – Umm Ramool', 'Umm Ramool', 'RTA Customer Happiness Centre Umm Ramool Dubai'), GuidePlace('RTA accredited eye test', 'Dubai', 'RTA eye test centre Dubai')],
    warning: 'Ehliyet uygunluğu licence origin, nationality ve belge türüne göre RTA ekranında değişebilir. Son kararı RTA hizmet ekranındaki seçime göre ver.',
  ),
  GuideArticle(
    id: 'vehicle-registration', category: 'Araç & Ulaşım', title: 'Araç satın alma, sigorta & RTA registration',
    subtitle: 'Aracı teslim almadan önce sigorta, inspection ve ownership sırasını kontrol et.',
    icon: Icons.directions_car_rounded, order: 12, featured: true,
    steps: [
      'İkinci el araçta şasi/VIN, mevcut registration, mortgage/finance durumu ve varsa fines/inspection gerekliliklerini kontrol et.',
      'Registration/transfer için geçerli motor insurance gerekir; poliçedeki araç ve sürücü bilgilerini kontrol et.',
      'RTA’nın gerekli gördüğü durumda vehicle inspection işlemini yetkili centre’da tamamla.',
      'RTA Website/App, Customer Happiness Centre veya Vehicle Registration & Inspection Centre üzerinden ownership/registration işlemini tamamla.',
      'Yeni ownership card/mulkiya ve plate detaylarını kontrol et. Sigorta poliçesini ve inspection raporunu sakla.',
      'Aracı kullanmadan Salik hesabı/tag durumunu ve Dubai parking yöntemlerini hazırla.',
    ],
    checklist: ['Emirates ID', 'UAE driving licence', 'Vehicle insurance', 'Vehicle/ownership documents', 'Inspection sonucu gerekiyorsa', 'Satıcı/alıcı bilgileri'],
    links: [GuideLink('RTA – Register a New Vehicle', 'https://www.rta.ae/wps/portal/rta/ae/home/rta-services/service-details?serviceId=520'), GuideLink('RTA – ana site', 'https://www.rta.ae/'), GuideLink('UAE Central Bank – insurance consumer resources', 'https://www.centralbank.ae/en/consumer/')],
    places: [GuidePlace('Tasjeel vehicle testing', 'Dubai', 'Tasjeel vehicle testing Dubai'), GuidePlace('RTA Vehicle Registration & Inspection Centre', 'Dubai', 'RTA vehicle registration inspection centre Dubai')],
    warning: 'BizimDubai sigorta ürünü önermiyor. Third-party/comprehensive kapsam, excess, agency repair, roadside assistance ve exclusions maddelerini poliçenin KFS/wording belgesinden karşılaştır.',
  ),
  GuideArticle(
    id: 'salik-parking', category: 'Araç & Ulaşım', title: 'Salik, toll & Dubai parking',
    subtitle: 'Aracı aldıktan sonra unutulan iki temel günlük işlem.',
    icon: Icons.toll_rounded, order: 13,
    steps: ['Salik hesabını/tag durumunu resmî Salik kanalından kontrol et ve aracı doğru traffic file/account ile bağla.', 'Plaka bilgilerini doğru gir; araç değişiminde eski araç ile yeni aracı karıştırma.', 'RTA Dubai uygulamasında parking zone kodu ve plaka bilgilerini kontrol ederek park ödemesini yap.', 'SMS/uygulama makbuzlarını özellikle rental/temporary plate durumlarında sakla.'],
    checklist: ['Vehicle plate details', 'Traffic file / account data', 'UAE mobile number'],
    links: [GuideLink('Salik resmî site', 'https://www.salik.ae/en'), GuideLink('RTA Dubai', 'https://www.rta.ae/')],
  ),
  GuideArticle(
    id: 'health-insurance', category: 'Sağlık', title: 'Sağlık sigortası & hastane kullanımı',
    subtitle: 'Policy network, co-pay ve emergency kullanımını ilk günden öğren.',
    icon: Icons.health_and_safety_rounded, order: 14, featured: true,
    steps: ['İşveren/sponsor tarafından verilen health insurance policy’nin kartını veya dijital poliçe numarasını al.', 'Network listesini aç; “hangi hastane iyi” sorusundan önce poliçenin hangi hastaneyi kapsadığını kontrol et.', 'Outpatient, specialist referral, pharmacy, dental/maternity, co-pay, annual limit ve pre-approval kurallarını not et.', 'Acil durumda 998 ambulans, 999 polis; hayatı tehdit eden durumda sigorta onayı bekleme.', 'Plan değiştiğinde yeni network listesini yeniden kontrol et.'],
    checklist: ['Insurance card/policy number', 'Emirates ID', 'Network PDF/app', 'Pre-approval contact', 'Emergency numbers'],
    links: [GuideLink('Dubai Health Authority', 'https://www.dha.gov.ae/'), GuideLink('Dubai Health – facilities', 'https://dubaihealth.ae/'), GuideLink('UAE Government – emergency contacts', 'https://u.ae/en/information-and-services/justice-safety-and-the-law/handling-emergencies')],
    places: [GuidePlace('Dubai Hospital', 'Deira', 'Dubai Hospital Dubai'), GuidePlace('Rashid Hospital', 'Oud Metha', 'Rashid Hospital Dubai'), GuidePlace('Latifa Hospital', 'Al Jaddaf', 'Latifa Hospital Dubai')],
    tips: ['Doktor seçerken “network içinde mi?” sorusunu hem hastane hem sigorta uygulamasından doğrula.'],
  ),
  GuideArticle(
    id: 'schools', category: 'Aile & Eğitim', title: 'Okul / nursery seçimi',
    subtitle: 'KHDA dizini, bölge, curriculum ve toplam yıllık maliyet.',
    icon: Icons.school_rounded, order: 15,
    steps: ['KHDA school directory üzerinden curriculum, location ve school bilgilerini filtrele.', 'Ev-okul trafik süresini sabah ve okul çıkış saatlerinde haritada ayrı kontrol et.', 'Tuition dışında registration, transport, uniform, meals, activities ve device maliyetlerini sor.', 'Seat availability ve admission assessment tarihini okuldan yazılı teyit et.', 'Final seçimden önce KHDA yayımlanan okul bilgisi ile okulun kendi fee sheet’ini karşılaştır.'],
    checklist: ['Çocuğun pasaportu/ID', 'Önceki school records', 'Vaccination/medical records gerektiğinde', 'Transfer certificate gerekliliği için okul teyidi'],
    links: [GuideLink('KHDA', 'https://web.khda.gov.ae/en/'), GuideLink('KHDA – Education Directory', 'https://web.khda.gov.ae/en/Education-Directory/Schools')],
    places: [GuidePlace('KHDA', 'Academic City', 'KHDA Dubai')],
  ),
  GuideArticle(
    id: 'employment', category: 'İş & Kariyer', title: 'İş sözleşmesi & çalışan olarak ilk kontroller',
    subtitle: 'Offer, contract, work permit, salary ve benefits kayıtlarını tek yerde tut.',
    icon: Icons.work_history_outlined, order: 16,
    steps: ['İmzalı offer/contract PDF’ini sakla; job title, basic salary, allowances, probation, notice, leave ve benefits satırlarını kontrol et.', 'Work permit/residency sponsor bilgilerini işverenle doğrula.', 'Maaş hesabı açıldıktan sonra salary transfer/WPS bilgilerini kontrol et.', 'Health insurance kartını ve policy network’ünü al.', 'Sözleşme veya iş ilişkisi konusunda resmî açıklama gerektiğinde MOHRE’nin güncel hizmet/iletişim kanallarını kullan.'],
    checklist: ['Signed offer/contract', 'Work permit info', 'Emirates ID', 'Salary certificate', 'Insurance policy'],
    links: [GuideLink('MOHRE', 'https://www.mohre.gov.ae/'), GuideLink('UAE Government – jobs', 'https://u.ae/en/information-and-services/jobs')],
    warning: 'Bu bölüm hukuki danışmanlık değildir; resmi süreç ve belge organizasyonu içindir.',
  ),
  GuideArticle(
    id: 'emergency', category: 'Kimlik & Resmî', title: 'Acil durum: tek ekranda numaralar',
    subtitle: 'Polis 999 · Ambulans 998 · DEWA emergency 991.',
    icon: Icons.emergency_rounded, order: 17, featured: true,
    steps: ['Hayati acil durumda 999 polis veya 998 ambulans numarasını ara.', 'Elektrik/su teknik acilinde DEWA 991 kanalını kullan.', 'Pasaport kaybında police report ve ardından konsolosluk sürecini başlat.', 'Sigorta/roadside assistance numaralarını telefonunda ayrıca kaydet.'],
    checklist: ['999 Police', '998 Ambulance', '991 DEWA emergency', 'Sigorta acil hattı', 'Konsolosluk iletişimi'],
    links: [GuideLink('Dubai Police', 'https://www.dubaipolice.gov.ae/'), GuideLink('DEWA Customer Care', 'https://www.dewa.gov.ae/en/consumer/useful-tools/customer-care-centre-services'), GuideLink('UAE Government emergency guide', 'https://u.ae/en/information-and-services/justice-safety-and-the-law/handling-emergencies')],
  ),
  GuideArticle(
    id: 'leaving-dubai', category: 'Ayrılış', title: 'Dubai’den ayrılıyorum: kapanış sırası',
    subtitle: 'Ev, DEWA, internet, banka, araç ve final bill’leri kontrollü kapat.',
    icon: Icons.flight_takeoff_rounded, order: 18, featured: true,
    steps: ['Tenancy notice/hand-over tarihini kontrat şartlarına göre planla ve yazılı kayıt tut.', 'Ejari cancellation/termination durumunu DLD/Dubai REST üzerinden kontrol et.', 'DEWA Move-out ile disconnect tarihini seç, final bill ve security deposit refund sürecini takip et.', 'du/e& internet ve mobil kontratlarında early termination/final bill durumunu kapatmadan önce sor.', 'Aracın satış/transferini ve Salik hesabındaki araç bağlantısını güncelle.', 'Banka hesabını ancak maaş, deposit refund, card/loan ve tüm standing orders kapandıktan sonra değerlendir.', 'Final clearance, receipts ve handover fotoğraflarını bulutta sakla.'],
    checklist: ['Tenancy handover', 'Ejari status', 'DEWA final bill', 'Telecom final bill', 'Vehicle transfer', 'Salik', 'Bank/credit card balances'],
    links: [GuideLink('DEWA – Move-out', 'https://www.dewa.gov.ae/en/about-us/service-guide/consumer-services/move-out'), GuideLink('DLD', 'https://dubailand.gov.ae/en/'), GuideLink('RTA', 'https://www.rta.ae/'), GuideLink('Salik', 'https://www.salik.ae/en')],
  ),
];

Future<void> _openGuideUrl(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  try {
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
  } catch (_) {}
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bağlantı açılamadı. İnternet veya cihaz ayarlarını kontrol edin.')));
  }
}

Uri _guideMapUri(String query) => Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': query});
Uri _guideWazeUri(String query) => Uri.https('www.waze.com', '/ul', {'q': query, 'navigate': 'yes'});

class PremiumGuidePage extends StatefulWidget {
  const PremiumGuidePage({super.key});
  @override
  State<PremiumGuidePage> createState() => _PremiumGuidePageState();
}

class _PremiumGuidePageState extends State<PremiumGuidePage> {
  String query = '';
  String? category;
  @override
  Widget build(BuildContext context) {
    final q = query.trim().toLowerCase();
    final items = guideArticles.where((a) =>
      (category == null || a.category == category) &&
      (q.isEmpty || '${a.title} ${a.subtitle} ${a.category} ${a.steps.join(' ')}'.toLowerCase().contains(q))).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return SafeArea(child: CustomScrollView(slivers: [
      SliverPadding(padding: const EdgeInsets.fromLTRB(18, 14, 18, 10), sliver: SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const BrandHeader(compact: true), const SizedBox(height: 20),
        const Text('Dubai Rehberi', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 29, letterSpacing: -.8)),
        const SizedBox(height: 5),
        const Text('Ne yapacağını değil, hangi sırayla ve nereden yapacağını gösterir.', style: TextStyle(color: _guideMuted, fontWeight: FontWeight.w600, height: 1.35)),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE30613), Color(0xFFB80010)]), borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Color(0x22E30613), blurRadius: 24, offset: Offset(0, 8))]), child: Row(children: [
          Container(width: 54, height: 54, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .16), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28)),
          const SizedBox(width: 14),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Dubai’ye yeni mi geldin?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)), SizedBox(height: 5), Text('SIM → Emirates ID → UAE Pass → banka → ev → Ejari → DEWA → ulaşım', style: TextStyle(color: Colors.white, height: 1.35, fontSize: 12, fontWeight: FontWeight.w600))])),
          IconButton.filled(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GuideJourneyPage())), style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: _guideRed), icon: const Icon(Icons.arrow_forward_rounded))
        ])),
        const SizedBox(height: 16),
        TextField(onChanged: (v) => setState(() => query = v), decoration: InputDecoration(hintText: 'Ehliyet, banka, sigorta, Ejari, SIM ara…', prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE7E9ED)), borderRadius: BorderRadius.circular(18)), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE7E9ED)), borderRadius: BorderRadius.circular(18)))),
        const SizedBox(height: 14),
        SizedBox(height: 42, child: ListView(scrollDirection: Axis.horizontal, children: [
          Padding(padding: const EdgeInsets.only(right: 8), child: FilterChip(label: const Text('Tümü'), selected: category == null, onSelected: (_) => setState(() => category = null))),
          for (final c in guideCategories) Padding(padding: const EdgeInsets.only(right: 8), child: FilterChip(avatar: Icon(c.$2, size: 16), label: Text(c.$1), selected: category == c.$1, onSelected: (_) => setState(() => category = c.$1))),
        ])),
        const SizedBox(height: 18),
        Row(children: [const Expanded(child: Text('Tam donanımlı kütüphane', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))), Text('${items.length} rehber', style: const TextStyle(color: _guideMuted, fontSize: 12, fontWeight: FontWeight.w700))]),
      ]))),
      if (items.isEmpty) const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(32), child: Center(child: Text('Bu aramayla eşleşen rehber bulunamadı.')))),
      SliverPadding(padding: const EdgeInsets.fromLTRB(18, 0, 18, 120), sliver: SliverList.builder(itemCount: items.length, itemBuilder: (_, i) => Padding(padding: const EdgeInsets.only(bottom: 11), child: _GuideLibraryCard(article: items[i])))),
    ]));
  }
}

class _GuideLibraryCard extends StatelessWidget {
  const _GuideLibraryCard({required this.article});
  final GuideArticle article;
  @override
  Widget build(BuildContext context) => Material(color: Colors.white, borderRadius: BorderRadius.circular(22), clipBehavior: Clip.antiAlias, child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GuideArticlePage(article: article))), child: Padding(padding: const EdgeInsets.all(15), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(width: 50, height: 50, decoration: BoxDecoration(color: const Color(0xFFFFECEE), borderRadius: BorderRadius.circular(16)), child: Icon(article.icon, color: _guideRed, size: 25)),
    const SizedBox(width: 13),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(article.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15.5))), if (article.featured) Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFFECEE), borderRadius: BorderRadius.circular(8)), child: const Text('ÖNEMLİ', style: TextStyle(color: _guideRed, fontSize: 8.5, fontWeight: FontWeight.w900)))]),
      const SizedBox(height: 5), Text(article.subtitle, style: const TextStyle(color: _guideMuted, fontSize: 12, height: 1.35, fontWeight: FontWeight.w600)),
      const SizedBox(height: 9), Wrap(spacing: 6, runSpacing: 5, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFF4F5F7), borderRadius: BorderRadius.circular(7)), child: Text(article.category, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700)), Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFF4F5F7), borderRadius: BorderRadius.circular(7)), child: Text('${article.links.length} resmî bağlantı', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700))]),
    ])), const SizedBox(width: 8), const Icon(Icons.chevron_right_rounded, color: _guideRed)
  ]))));
}

class GuideJourneyPage extends StatelessWidget {
  const GuideJourneyPage({super.key});
  @override
  Widget build(BuildContext context) {
    const ids = ['sim', 'emirates-id', 'uae-pass', 'bank-account', 'rent-home', 'ejari', 'dewa', 'nol', 'health-insurance', 'driving-licence'];
    final items = [for (final id in ids) guideArticles.firstWhere((a) => a.id == id)];
    return Scaffold(appBar: AppBar(title: const Text('Yeni gelenler yol haritası', style: TextStyle(fontWeight: FontWeight.w900))), body: ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 40), children: [
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFFFECEE), borderRadius: BorderRadius.circular(22)), child: const Text('Bu sıra çoğu yeni resident için pratik başlangıç sırasıdır. Oturum/sponsor durumuna göre bazı adımlar paralel ilerleyebilir.', style: TextStyle(fontWeight: FontWeight.w700, height: 1.45))),
      const SizedBox(height: 18),
      for (var i = 0; i < items.length; i++) InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GuideArticlePage(article: items[i]))), child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Row(children: [CircleAvatar(radius: 17, backgroundColor: _guideRed, foregroundColor: Colors.white, child: Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(items[i].title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(items[i].subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _guideMuted, fontSize: 11.5))])), const Icon(Icons.chevron_right, color: _guideRed)]))),
    ]));
  }
}

class GuideArticlePage extends StatelessWidget {
  const GuideArticlePage({super.key, required this.article});
  final GuideArticle article;
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: const Color(0xFFF7F8FA), appBar: AppBar(title: Text(article.category, style: const TextStyle(fontWeight: FontWeight.w800))), body: ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 40), children: [
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 52, height: 52, decoration: BoxDecoration(color: const Color(0xFFFFECEE), borderRadius: BorderRadius.circular(16)), child: Icon(article.icon, color: _guideRed, size: 27)),
      const SizedBox(height: 16), Text(article.title, style: const TextStyle(fontSize: 26, height: 1.12, fontWeight: FontWeight.w900, letterSpacing: -.5)), const SizedBox(height: 8), Text(article.subtitle, style: const TextStyle(color: _guideMuted, height: 1.5, fontWeight: FontWeight.w600)),
    ])),
    const SizedBox(height: 18),
    const _GuideSectionHeader('Adım adım'),
    for (var i = 0; i < article.steps.length; i++) Container(margin: const EdgeInsets.only(bottom: 9), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(radius: 15, backgroundColor: _guideRed, foregroundColor: Colors.white, child: Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10))), const SizedBox(width: 11), Expanded(child: Text(article.steps[i], style: const TextStyle(height: 1.45, fontWeight: FontWeight.w650)))])),
    const SizedBox(height: 12), const _GuideSectionHeader('Hazırla'),
    Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Column(children: [for (final item in article.checklist) Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.check_circle_rounded, size: 18, color: Color(0xFF1E9D58)), const SizedBox(width: 9), Expanded(child: Text(item, style: const TextStyle(fontWeight: FontWeight.w700)))]))])),
    if (article.places.isNotEmpty) ...[
      const SizedBox(height: 20), const _GuideSectionHeader('Nereye gidebilirim?'),
      for (final place in article.places) Container(margin: const EdgeInsets.only(bottom: 9), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(place.name, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(place.area, style: const TextStyle(color: _guideMuted, fontSize: 12)), if (place.note.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 5), child: Text(place.note, style: const TextStyle(fontSize: 11.5, height: 1.35))), const SizedBox(height: 10), Row(children: [Expanded(child: FilledButton.tonalIcon(onPressed: () => _openGuideUrl(context, _guideMapUri(place.query).toString()), icon: const Icon(Icons.map_outlined, size: 18), label: const Text('Google Maps'))), const SizedBox(width: 8), Expanded(child: OutlinedButton.icon(onPressed: () => _openGuideUrl(context, _guideWazeUri(place.query).toString()), icon: const Icon(Icons.directions_car_outlined, size: 18), label: const Text('Waze')))])]))
    ],
    const SizedBox(height: 20), const _GuideSectionHeader('Resmî kaynaklar'),
    for (final link in article.links) Container(margin: const EdgeInsets.only(bottom: 9), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: ListTile(onTap: () => _openGuideUrl(context, link.url), leading: Container(width: 38, height: 38, decoration: BoxDecoration(color: const Color(0xFFFFECEE), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.verified_outlined, color: _guideRed, size: 20)), title: Text(link.label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)), subtitle: link.note.isEmpty ? Text(Uri.parse(link.url).host, style: const TextStyle(fontSize: 11)) : Text(link.note, style: const TextStyle(fontSize: 11)), trailing: const Icon(Icons.open_in_new_rounded, size: 18))),
    if (article.tips.isNotEmpty) ...[
      const SizedBox(height: 18), const _GuideSectionHeader('İşe yarayan notlar'),
      Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFFFFF8E8), borderRadius: BorderRadius.circular(18)), child: Column(children: [for (final tip in article.tips) Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFB97800), size: 18), const SizedBox(width: 9), Expanded(child: Text(tip, style: const TextStyle(height: 1.4, fontWeight: FontWeight.w650)))]))]))
    ],
    if (article.warning != null) ...[
      const SizedBox(height: 18), Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFFFFECEE), borderRadius: BorderRadius.circular(18)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.info_outline_rounded, color: _guideRed), const SizedBox(width: 10), Expanded(child: Text(article.warning!, style: const TextStyle(height: 1.4, fontWeight: FontWeight.w700))) ]))
    ],
    const SizedBox(height: 18),
    const Text('Son kontrol: Eylül 2026. Ücretler, uygunluk ve belgeler değişebilir; işlem yapmadan önce yukarıdaki resmî sayfayı aç.', style: TextStyle(color: _guideMuted, fontSize: 11, height: 1.4)),
  ]));
}

class _GuideSectionHeader extends StatelessWidget {
  const _GuideSectionHeader(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(text, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: _guideInk)));
}
