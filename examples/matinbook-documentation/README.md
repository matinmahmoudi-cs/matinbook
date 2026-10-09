# MatinBook — راهنمای جامع (مستندات)

این پوشه شامل **راهنمای جامع MatinBook** به زبان فارسی است که
به صورت یک کتاب PDF با استفاده از خودِ کلاس `matinbook` تولید
می‌شود.

---

## فهرست مطالب

- [ساختار](#ساختار)
- [کامپایل](#کامپایل)
- [مشارکت](#مشارکت)
- [مجوز](#مجوز)

---

## ساختار

```
matinbook-documentation/
├── main.tex                     # فایل اصلی
├── references.bib               # کتاب‌نامه
├── README.md                    # این فایل
│
├── frontmatter/                 # پیشگفتار
│   ├── cover.tex
│   ├── colophon.tex
│   ├── dedication.tex
│   ├── preface.tex
│   └── about.tex
│
├── part1-getting-started/       # بخش ۱: شروع به کار
│   ├── ch01-introduction.tex
│   ├── ch02-installation.tex
│   ├── ch03-first-book.tex
│   └── ch04-book-structure.tex
│
├── part2-book-components/       # بخش ۲: اجزای کتاب
│   ├── ch05-cover.tex
│   ├── ch06-chapters.tex
│   ├── ch07-text.tex
│   ├── ch08-environments.tex
│   ├── ch09-math.tex
│   ├── ch10-code.tex
│   ├── ch11-graphics.tex
│   ├── ch12-tables.tex
│   ├── ch13-margin-notes.tex
│   ├── ch14-bibliography.tex
│   ├── ch15-index.tex
│   └── ch16-cross-refs.tex
│
├── part3-customization/         # بخش ۳: شخصی‌سازی
│   ├── ch17-options.tex
│   ├── ch18-colors.tex
│   ├── ch19-fonts.tex
│   ├── ch20-layout.tex
│   ├── ch21-themes.tex
│   └── ch22-localization.tex
│
├── part4-advanced/              # بخش ۴: پیشرفته
│   ├── ch23-modules.tex
│   ├── ch24-custom-theme.tex
│   ├── ch25-custom-commands.tex
│   └── ch26-large-projects.tex
│
├── part5-examples/              # بخش ۵: مثال‌ها
│   ├── ch27-math-book.tex
│   ├── ch28-programming-book.tex
│   └── ch29-physics-book.tex
│
├── part6-reference/             # بخش ۶: مرجع
│   ├── ch30-class-options.tex
│   ├── ch31-environments.tex
│   └── ch32-commands.tex
│
├── appendices/                  # پیوست‌ها
│   ├── app-a-troubleshooting.tex
│   ├── app-b-tools.tex
│   ├── app-c-resources.tex
│   ├── app-d-changelog.tex
│   └── app-e-license.tex
│
├── backmatter/                  # پس‌متن
│   ├── bibliography.tex
│   ├── index.tex
│   └── backcover.tex
│
└── images/                      # تصاویر
    ├── cover/
    ├── screenshots/
    └── diagrams/
```

---

## کامپایل

### کامپایل کامل (با کتاب‌نامه و نمایه)

```bash
# مرحله ۱: کامپایل اول
xelatex -shell-escape main.tex

# مرحله ۲: کتاب‌نامه
biber main

# مرحله ۳: کامپایل دوم (برای ارجاعات)
xelatex -shell-escape main.tex

# مرحله ۴: کامپایل سوم (برای فهرست مطالب و جلد)
xelatex -shell-escape main.tex
```

### با `latexmk`

```bash
latexmk -xelatex -shell-escape main.tex
```

### پاک‌سازی فایل‌های کمکی

```bash
latexmk -c main.tex
```

### نیازمندی‌ها

| ابزار | کاربرد |
|--------|--------|
| `xelatex` | موتور اصلی |
| `biber` | کتاب‌نامه |
| `xindy` | نمایه (مرتب‌سازی فارسی) |
| `pygmentize` | رنگ‌آمیزی کد |

---

## مشارکت

برای مشارکت در بهبود این مستندات:

1. یک فورک از مخزن بگیرید.
2. تغییرات خود را در یک برنچ جدید اعمال کنید.
3. تست کنید که کتاب بدون خطا کامپایل می‌شود.
4. یک Pull Request ارسال کنید.

### قواعد نگارش

- **فصل‌ها:** هر فصل در یک فایل جداگانه.
- **زبان:** فارسی، با \lr{} برای واژه‌های لاتین.
- **مثال‌ها:** هر مثال باید کد کامل و قابل اجرا داشته باشد.
- **ارجاع:** از `\cref` برای ارجاع بین فصل‌ها استفاده کنید.
- **تصاویر:** تصاویر خروجی در پوشه‌ی `images/` ذخیره شوند.

---

## مجوز

این مستندات، مانند خودِ MatinBook، تحت مجوز **MIT License**
منتشر می‌شود. برای جزئیات، فایل `LICENSE` در ریشه‌ی پروژه را
ببینید.

---

**MatinBook — نوشته شده با عشق برای نویسندگان فارسی‌زبان.**
