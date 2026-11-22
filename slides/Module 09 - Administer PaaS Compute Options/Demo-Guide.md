<div dir="rtl" align="right">

# מודול <bdi dir="ltr">09</bdi> — הדגמות <bdi dir="ltr">PaaS Compute</bdi>

מדריך מלווה נוסף למרצה עבור [המצגת](AZ-104T00A-ENU-PowerPoint_09.pptx), כולל <bdi dir="ltr">App Service</bdi>, <bdi dir="ltr">ACI</bdi> ו־<bdi dir="ltr">ACA</bdi>; הוא אינו משנה חומרים קיימים. אין צורך ב־<bdi dir="ltr">GitHub credentials</bdi>, <bdi dir="ltr">registry</bdi> פרטי או <bdi dir="ltr">AKS.</bdi> דפי <bdi dir="ltr">quickstart</bdi> הם נתוני דמו ציבוריים בלבד.

## מפת ההדגמות

| הדגמה | שקופיות | זמן משוער | מסלול |
| ---: | ---: | ---: | ---: |
| <bdi dir="ltr">1. Web App</bdi> ו־<bdi dir="ltr">App Service plan</bdi> | <span dir="ltr">6–10, 14–15, 18, 21</span> | <bdi dir="ltr">20</bdi> דקות | <bdi dir="ltr">F1</bdi> אם זמין; אחרת סקירה בלבד |
| <bdi dir="ltr">2. Deployment slots</bdi> ו־<bdi dir="ltr">scaling</bdi> | <span dir="ltr">8–9, 16–17, 21, 35–36</span> | <bdi dir="ltr">20</bdi> דקות | <bdi dir="ltr">S1</bdi> בתשלום, אופציונלי |
| <span dir="ltr">3. Azure Container Instances</span> | <span dir="ltr">25–29, 37–38</span> | <bdi dir="ltr">15</bdi> דקות | <bdi dir="ltr">container</bdi> קטן בתשלום |
| <bdi dir="ltr">4. Azure Container Apps</bdi> ו־<bdi dir="ltr">revision</bdi> | <span dir="ltr">30–32, 39–40, 45</span> | <bdi dir="ltr">20</bdi> דקות | <bdi dir="ltr">Consumption</bdi>, עד <bdi dir="ltr">replica</bdi> אחת |

## הכנה ובטיחות

1. היכנסו ל־<bdi dir="ltr">Azure portal > Settings > Directories + subscriptions</bdi> ואמתו <bdi dir="ltr">Tenant</bdi> ו־<bdi dir="ltr">Subscription ID.</bdi> אין <bdi dir="ltr">Azure sandbox</bdi> מובטח; <bdi dir="ltr">F1</bdi> ו־<bdi dir="ltr">Consumption</bdi> כפופים לתנאי המנוי ומכסות, ולא מבטיחים שכל המשאבים חינמיים.
2. צרו קבוצות דמו חדשות ב־<bdi dir="ltr">West Europe:</bdi> <bdi dir="ltr">`az104-demo09-web`</bdi>, <bdi dir="ltr">`az104-demo09-aci`</bdi>, <bdi dir="ltr">`az104-demo09-aca`</bdi>, עם <bdi dir="ltr">`Purpose=ClassroomDemo`</bdi>. קבוצות נפרדות מאפשרות ניקוי בלי למחוק אתרים/סביבות אחרים.
3. נדרש <bdi dir="ltr">Contributor</bdi> בקבוצות. <bdi dir="ltr">Subscriptions > Resource providers:</bdi> ודאו <bdi dir="ltr">Registered</bdi> עבור <bdi dir="ltr">`Microsoft.Web`</bdi>, <bdi dir="ltr">`Microsoft.ContainerInstance`</bdi>, <bdi dir="ltr">`Microsoft.App`</bdi>; ל־<bdi dir="ltr">workspace</bdi> אופציונלי גם <bdi dir="ltr">`Microsoft.OperationalInsights`</bdi>. אם חסרה הרשאת <bdi dir="ltr">registration</bdi>, בעל המנוי יטפל — אין לעקוף <bdi dir="ltr">Policy.</bdi>
4. שמות גלובליים לדוגמה <bdi dir="ltr">`az104-d09-web-261122`</bdi> ו־<bdi dir="ltr">DNS label</bdi> <bdi dir="ltr">`az104-d09-aci-261122`</bdi>; החליפו סיומת אם תפוס ורשמו שם בפועל. <bdi dir="ltr">region/SKU/capacity</bdi> עשויים להשתנות; <bdi dir="ltr">quota</bdi> חסר אינו סיבה לשדרג לשירות יקר.
5. אין לפרוס מידע אישי או <bdi dir="ltr">secrets.</bdi> אין לקבל <bdi dir="ltr">publish profile</bdi>, <bdi dir="ltr">account keys</bdi>, <bdi dir="ltr">SAS</bdi> או <bdi dir="ltr">connection strings.</bdi> אין <bdi dir="ltr">private registry authentication</bdi> בהדגמות. <bdi dir="ltr">Public sample endpoints</bdi> פתוחים לזמן הדמו בלבד.

## <bdi dir="ltr">1. Web App</bdi> ו־<bdi dir="ltr">App Service plan</bdi>

**מטרה:** לבצע את <bdi dir="ltr">demos</bdi> שקופיות <bdi dir="ltr">10</bdi> ו־<bdi dir="ltr">21</bdi> ולזהות שה־<bdi dir="ltr">plan</bdi> מחזיק את <bdi dir="ltr">compute</bdi> בעוד ה־<bdi dir="ltr">app</bdi> מחזיק <bdi dir="ltr">endpoint/configuration.</bdi>

**דרישות ומשאבים:** <bdi dir="ltr">`az104-demo09-web`</bdi>, <bdi dir="ltr">Contributor</bdi>, <bdi dir="ltr">F1</bdi> זמין למנוי/<bdi dir="ltr">region. App</bdi> <bdi dir="ltr">`az104-d09-web-261122`</bdi>, <bdi dir="ltr">plan</bdi> <bdi dir="ltr">`asp-demo09`</bdi>, <bdi dir="ltr">Windows</bdi>, קוד .<bdi dir="ltr">NET</bdi> נתמך.

### צעדים

1. <bdi dir="ltr">App Services > Create > Web App:</bdi> בחרו מנוי מאומת, קבוצת הדמו, השם הייחודי, <bdi dir="ltr">Publish</bdi> **<bdi dir="ltr">Code</bdi>**, <bdi dir="ltr">Runtime stack</bdi> **.<bdi dir="ltr">NET 10</bdi> (<bdi dir="ltr">LTS</bdi>)** אם מוצג ותומך באזור, <bdi dir="ltr">OS</bdi> **<bdi dir="ltr">Windows</bdi>**, <bdi dir="ltr">West Europe.</bdi> אם הגרסה אינה בקטלוג בחרו גרסת .<bdi dir="ltr">NET</bdi> נתמכת נוכחית ורשמו את ההחלפה; אין תלות בקוד יישום ספציפי בדמו זה.
2. <bdi dir="ltr">Windows plan > Create new</bdi> <bdi dir="ltr">`asp-demo09`</bdi>. <bdi dir="ltr">Pricing plan / Explore pricing plans:</bdi> בחרו **<bdi dir="ltr">Free F1</bdi>**, לא ברירת מחדל <bdi dir="ltr">Premium.</bdi> אם אינו זמין, עצרו לפני <bdi dir="ltr">Create</bdi>; חלופה בתשלום רק אחרי בדיקת תקציב.
3. <bdi dir="ltr">Networking: Public access On</bdi> לצורך דף פיקטיבי; ללא <bdi dir="ltr">VNet integration</bdi> או <bdi dir="ltr">private endpoint. Monitoring:</bdi> השביתו <bdi dir="ltr">Application Insights</bdi> אוטומטי אם אפשר כדי לא ליצור משאבים/<bdi dir="ltr">connection strings</bdi> שלא נדרשים.
4. <bdi dir="ltr">Deployment:</bdi> ללא <bdi dir="ltr">continuous deployment</bdi>, ללא התחברות ל־<bdi dir="ltr">GitHub</bdi> וללא <bdi dir="ltr">basic publishing credentials. Review + create:</bdi> בדקו <bdi dir="ltr">plan F1</bdi> ומשאבים נלווים, ואז <bdi dir="ltr">Create.</bdi>
5. אחרי <bdi dir="ltr">Succeeded</bdi>, <bdi dir="ltr">App > Overview: Status Running</bdi>; פתחו **<bdi dir="ltr">Default domain</bdi>** מתוך הפורטל — שמות <bdi dir="ltr">hostname</bdi> יכולים לכלול סיומת <bdi dir="ltr">hash</bdi>, אין לבנות אותם מניחוש.
6. הדף הצפוי הוא <bdi dir="ltr">default landing page</bdi> של השירות, לא <bdi dir="ltr">Hello World</bdi> שהעלינו. אם מוצג דף “<bdi dir="ltr">Your web app is running and waiting for your content</bdi>”, זו תוצאה תקינה. עדיין לא פרסנו <bdi dir="ltr">application code.</bdi>
7. <bdi dir="ltr">App > Settings > Configuration / General settings:</bdi> הפעילו <bdi dir="ltr">HTTPS Only</bdi>, ובחרו <bdi dir="ltr">minimum inbound TLS 1.2</bdi> או גבוה יותר אם נתמך. שמרו רק הגדרות אלה.
8. <bdi dir="ltr">App > App Service plan:</bdi> פתחו <bdi dir="ltr">`asp-demo09`</bdi>, הראו <bdi dir="ltr">region</bdi>, <bdi dir="ltr">OS</bdi> ו־<bdi dir="ltr">tier. Scale up:</bdi> הציגו <bdi dir="ltr">Basic/Standard/Premium</bdi> בלי לשמור; <bdi dir="ltr">Scale out</bdi> ב־<bdi dir="ltr">F1</bdi> אינו זמין.
9. <bdi dir="ltr">App > Networking > Access restrictions:</bdi> הציגו את האפשרות להגבלת כניסה ואת ההפרדה מ־<bdi dir="ltr">VNet integration</bdi> ל־<bdi dir="ltr">outbound.</bdi> אל תשמרו כלל שחוסם אתכם.
10. <bdi dir="ltr">Custom domains/Backups:</bdi> סקירה בלבד. <bdi dir="ltr">Custom domain</bdi> דורש בעלות על <bdi dir="ltr">DNS</bdi> ו־<bdi dir="ltr">tier</bdi> נתמך; <bdi dir="ltr">Backup capabilities</bdi> משתנות לפי <bdi dir="ltr">tier/type</bdi> ואינן <bdi dir="ltr">Azure Backup.</bdi> אין <bdi dir="ltr">domain</bdi>, <bdi dir="ltr">storage destination</bdi> או <bdi dir="ltr">database</bdi> שנוצרו בדמו.

**תוצאה ואימות:** <bdi dir="ltr">App Running</bdi>, <bdi dir="ltr">default landing page</bdi> דרך <bdi dir="ltr">HTTPS</bdi>, <bdi dir="ltr">plan F1.</bdi> בדקו ב־<bdi dir="ltr">RG</bdi> שנוצרו רק <bdi dir="ltr">app/plan</bdi> ומשאבים שאושרו.

**תצפית הוראתית:** ניתן לשייך מספר <bdi dir="ltr">apps</bdi> לאותו <bdi dir="ltr">plan</bdi>; הן חולקות <bdi dir="ltr">capacity</bdi>, <bdi dir="ltr">scaling</bdi> ועלות. דף פלטפורמה אינו הוכחת <bdi dir="ltr">deployment pipeline</bdi> או בריאות קוד.

**תקלות:** שם תפוס; <bdi dir="ltr">F1 quota</bdi>; <bdi dir="ltr">region</bdi> אינו תומך שילוב <bdi dir="ltr">OS/runtime</bdi>; דף לא עולה מיד לאחר <bdi dir="ltr">deployment.</bdi> בדקו <bdi dir="ltr">Overview</bdi> ו־<bdi dir="ltr">Diagnose and solve problems</bdi>; אל תפעילו <bdi dir="ltr">tracing</bdi> בתשלום באופן אוטומטי.

**ניקוי:** השאירו רק אם ממשיכים להדגמה <bdi dir="ltr">2.</bdi> אחרת מחקו <bdi dir="ltr">app</bdi> **וגם <bdi dir="ltr">plan</bdi>** של הדמו; מחיקת <bdi dir="ltr">app</bdi> בלבד משאירה <bdi dir="ltr">plan</bdi> בתשלום אם שודרג.

## <bdi dir="ltr">2. Deployment slots</bdi> ו־<bdi dir="ltr">scaling</bdi> — הרחבה אופציונלית

**מטרה:** להראות <bdi dir="ltr">slot</bdi> בעל <bdi dir="ltr">hostname</bdi> עצמאי ו־<bdi dir="ltr">sticky settings</bdi>; לא לטעון שבוצע <bdi dir="ltr">deployment</bdi> של קוד חדש כשמחליפים רק <bdi dir="ltr">configuration.</bdi>

**דרישות ומשאבים:** <bdi dir="ltr">Web App</bdi> מהדגמה <bdi dir="ltr">1</bdi>, <bdi dir="ltr">Contributor</bdi>, תקציב לשדרוג זמני ל־**<bdi dir="ltr">Standard S1</bdi>**. <bdi dir="ltr">Slot</bdi> <bdi dir="ltr">`staging`</bdi>. ב־<bdi dir="ltr">F1/Basic</bdi> אין <bdi dir="ltr">slots</bdi>; החלופה היא קריאת התיעוד ואשף <bdi dir="ltr">Scale up</bdi> ללא שמירה.

### צעדים

1. <bdi dir="ltr">Plan</bdi> <bdi dir="ltr">`asp-demo09`</bdi> > <bdi dir="ltr">Scale up:</bdi> בחרו <bdi dir="ltr">S1</bdi>, בדקו מחיר ואז <bdi dir="ltr">Apply</bdi> רק אם התקציב אושר. <bdi dir="ltr">Plan</bdi> מחויב גם כשה־<bdi dir="ltr">app</bdi> במצב <bdi dir="ltr">Stop.</bdi>
2. <bdi dir="ltr">App > Deployment slots > Add slot:</bdi> שם <bdi dir="ltr">`staging`</bdi>, <bdi dir="ltr">Clone settings from production. Add. Slot</bdi> חולק <bdi dir="ltr">plan</bdi> ואינו <bdi dir="ltr">compute plan</bdi> חדש.
3. פתחו <bdi dir="ltr">staging > Overview > Default domain</bdi> ופתחו אותו בנפרד מה־<bdi dir="ltr">production.</bdi> שתי הכתובות פעילות; התוכן עדיין <bdi dir="ltr">default page</bdi>, לא שני <bdi dir="ltr">releases</bdi> שונים.
4. <bdi dir="ltr">Production > Settings > Environment variables / App settings:</bdi> הוסיפו <bdi dir="ltr">`DEMO_RELEASE=release-a`</bdi> ו־<bdi dir="ltr">`DEMO_ENV=production`</bdi>. סמנו **<bdi dir="ltr">Deployment slot setting</bdi>** עבור <bdi dir="ltr">`DEMO_ENV`</bdi> בלבד. אלה ערכים פיקטיביים, לא <bdi dir="ltr">credentials. Apply.</bdi>
5. ב־<bdi dir="ltr">staging</bdi> הוסיפו <bdi dir="ltr">`DEMO_RELEASE=release-b`</bdi>, <bdi dir="ltr">`DEMO_ENV=staging`</bdi>; סמנו <bdi dir="ltr">sticky</bdi> רק עבור <bdi dir="ltr">`DEMO_ENV`</bdi>. <bdi dir="ltr">Apply</bdi> והמתינו ל־<bdi dir="ltr">restart.</bdi>
6. <bdi dir="ltr">Deployment slots > Swap: Source staging</bdi>, <bdi dir="ltr">Target production. Review changes</bdi> ובדקו ש־<bdi dir="ltr">DEMO_RELEASE</bdi> נכלל וש־<bdi dir="ltr">DEMO_ENV</bdi> נשאר <bdi dir="ltr">slot-specific.</bdi> אשרו <bdi dir="ltr">Swap.</bdi>
7. אחרי <bdi dir="ltr">completion</bdi> בדקו <bdi dir="ltr">App settings: production</bdi> אמור להחזיק <bdi dir="ltr">`release-b`</bdi> ו־<bdi dir="ltr">`production`</bdi>; <bdi dir="ltr">staging</bdi> <bdi dir="ltr">`release-a`</bdi> ו־<bdi dir="ltr">`staging`</bdi>. אין לצפות שה־<bdi dir="ltr">default webpage</bdi> תציג ערכים אלה — אין קוד שקורא אותם.
8. בצעו <bdi dir="ltr">Swap</bdi> הפוך לצורך <bdi dir="ltr">rollback</bdi> תצורה ואמתו החזרה. אין <bdi dir="ltr">database migrations</bdi> או <bdi dir="ltr">external state</bdi> בדמו.
9. <bdi dir="ltr">Plan > Scale out:</bdi> במצב <bdi dir="ltr">Manual</bdi> הגדילו מ־<bdi dir="ltr">`1`</bdi> ל־<bdi dir="ltr">`2`</bdi> <bdi dir="ltr">instances</bdi> רק אם התקציב מאושר. לאחר עדכון החזירו ל־<bdi dir="ltr">`1`</bdi>; אימות דרך <bdi dir="ltr">Instance count/metrics</bdi> בפורטל, לא רק <bdi dir="ltr">desired value.</bdi>
10. <bdi dir="ltr">Custom autoscale:</bdi> הציגו <bdi dir="ltr">draft</bdi> עם <bdi dir="ltr">Min/Default</bdi> <bdi dir="ltr">`1`</bdi>, <bdi dir="ltr">Max</bdi> <bdi dir="ltr">`2`</bdi>, <bdi dir="ltr">scale out CPU Average ></bdi><bdi dir="ltr">70</bdi>% במשך <bdi dir="ltr">10</bdi> דקות, +<bdi dir="ltr">1</bdi>, <bdi dir="ltr">cooldown 5</bdi> דקות; <bdi dir="ltr">scale in</bdi> <<bdi dir="ltr">30</bdi>% במשך <bdi dir="ltr">10</bdi> דקות, −<bdi dir="ltr">1</bdi>, <bdi dir="ltr">cooldown 5</bdi> דקות. **אל תשמרו** במסלול זה.
11. הסבירו ההבדל בין <bdi dir="ltr">Azure Monitor rule-based autoscale</bdi> לבין <bdi dir="ltr">App Service Automatic scaling</bdi> הזמין רק ב־<bdi dir="ltr">tiers</bdi> נתמכים. אין <bdi dir="ltr">workload</bdi> שיבטיח <bdi dir="ltr">trigger</bdi> בזמן השיעור.

**תוצאה ואימות:** שני <bdi dir="ltr">hostnames</bdi>, החלפת <bdi dir="ltr">setting</bdi> לא־<bdi dir="ltr">sticky</bdi> ושמירת <bdi dir="ltr">sticky setting. manual count</bdi> חוזר ל־<bdi dir="ltr">1</bdi>; לא הודגם <bdi dir="ltr">release code</bdi> או <bdi dir="ltr">SLA</bdi> נטול <bdi dir="ltr">downtime.</bdi>

**תצפית הוראתית:** <bdi dir="ltr">clone</bdi> אינו משכפל אוטומטית <bdi dir="ltr">application content</bdi>; <bdi dir="ltr">swap</bdi> אינו מעביר כל <bdi dir="ltr">setting.</bdi> יש לבדוק <bdi dir="ltr">authentication</bdi>, <bdi dir="ltr">certificates</bdi>, <bdi dir="ltr">domains</bdi> ו־<bdi dir="ltr">external dependencies</bdi> בנפרד.

**תקלות:** <bdi dir="ltr">Add slot</bdi> חסר → <bdi dir="ltr">plan</bdi> לא <bdi dir="ltr">S1</bdi> ומעלה או <bdi dir="ltr">upgrade</bdi> טרם הסתיים. ערך לא עבר → <bdi dir="ltr">sticky flag</bdi> או <bdi dir="ltr">swap target</bdi> לא נכון. <bdi dir="ltr">cache/default page</bdi> זהה אינו כישלון <bdi dir="ltr">swap</bdi> של <bdi dir="ltr">setting.</bdi>

**ניקוי:** מחקו <bdi dir="ltr">`staging`</bdi> לאחר <bdi dir="ltr">rollback.</bdi> הסירו רק שני <bdi dir="ltr">settings</bdi> של הדמו. אם רוצים לחזור ל־<bdi dir="ltr">F1</bdi>, ודאו שאין <bdi dir="ltr">slots/features</bdi> שמונעים <bdi dir="ltr">downgrade</bdi>; אם לא, מחקו <bdi dir="ltr">app</bdi> ו־<bdi dir="ltr">plan</bdi> של הדמו במקום להשאיר <bdi dir="ltr">S1</bdi> מחויב. אין לשנות <bdi dir="ltr">plan</bdi> שמשרת <bdi dir="ltr">apps</bdi> אחרים.

## <span dir="ltr">3. Azure Container Instances</span>

**מטרה:** לפרוס <bdi dir="ltr">container group</bdi> קטן מ־<bdi dir="ltr">image</bdi> ציבורי של <bdi dir="ltr">Microsoft</bdi> ולוודא <bdi dir="ltr">endpoint/logs.</bdi>

**דרישות ומשאבים:** <bdi dir="ltr">`az104-demo09-aci`</bdi>, <bdi dir="ltr">Contributor</bdi>, <bdi dir="ltr">ACI quota</bdi> לפחות <bdi dir="ltr">1 vCPU</bdi> ו־<bdi dir="ltr">1 GiB Linux. Container group</bdi> <bdi dir="ltr">`aci-demo09`</bdi>, <bdi dir="ltr">image</bdi> <bdi dir="ltr">`mcr.microsoft.com/azuredocs/aci-helloworld:latest`</bdi>.

### צעדים

1. <bdi dir="ltr">Container instances > Create:</bdi> המנוי המאומת, קבוצת <bdi dir="ltr">ACI</bdi>, <bdi dir="ltr">`aci-demo09`</bdi>, <bdi dir="ltr">West Europe</bdi>, <bdi dir="ltr">Linux</bdi>, <bdi dir="ltr">image source</bdi> **<bdi dir="ltr">Quickstart images</bdi>** או <bdi dir="ltr">Public registry</bdi> עם ה־<bdi dir="ltr">image</bdi> לעיל. אין <bdi dir="ltr">registry credentials.</bdi>
2. <bdi dir="ltr">Size:</bdi> <bdi dir="ltr">`1`</bdi> <bdi dir="ltr">vCPU</bdi>, <bdi dir="ltr">`1 GiB`</bdi> <bdi dir="ltr">memory</bdi> אם נתמך; ללא <bdi dir="ltr">GPU</bdi>, ללא <bdi dir="ltr">zone pinning</bdi> לצורך הפשטה.
3. <bdi dir="ltr">Networking: Public</bdi>, <bdi dir="ltr">TCP port</bdi> <bdi dir="ltr">`80`</bdi>, <bdi dir="ltr">DNS label</bdi> <bdi dir="ltr">`az104-d09-aci-261122`</bdi>. <bdi dir="ltr">DNS name label scope reuse</bdi> **<bdi dir="ltr">Tenant</bdi>** אם האפשרות מוצגת; השתמשו ב־<bdi dir="ltr">FQDN</bdi> בפועל לאחר פריסה, שיכול להכיל <bdi dir="ltr">hash.</bdi>
4. <bdi dir="ltr">Advanced: Restart policy</bdi> **<bdi dir="ltr">Always</bdi>**, ללא <bdi dir="ltr">environment secrets</bdi> או <bdi dir="ltr">volume mount</bdi>, ללא <bdi dir="ltr">Log Analytics integration</bdi> לא נחוצה. <bdi dir="ltr">Review + create</bdi> ואז <bdi dir="ltr">Create.</bdi>
5. אחרי <bdi dir="ltr">Succeeded</bdi>, <bdi dir="ltr">Overview: state Running</bdi>; פתחו את <bdi dir="ltr">FQDN</bdi> בפועל באמצעות **<bdi dir="ltr">HTTP</bdi>**. <bdi dir="ltr">image quickstart</bdi> זה מאזין ב־<bdi dir="ltr">80</bdi> ללא <bdi dir="ltr">TLS</bdi>; לא שולחים אליו מידע רגיש.
6. הדף אמור להציג את הודעת <bdi dir="ltr">welcome</bdi> של <bdi dir="ltr">ACI quickstart. Containers > Logs:</bdi> רעננו אחרי בקשת דפדפן; הציגו <bdi dir="ltr">stdout</bdi> של <bdi dir="ltr">sample</bdi> בלבד. אין הבטחה שכל <bdi dir="ltr">HTTP request</bdi> מופיע כ־<bdi dir="ltr">log.</bdi>
7. <bdi dir="ltr">Containers > Properties:</bdi> הציגו <bdi dir="ltr">CPU/memory/image.</bdi> הסבירו שכל <bdi dir="ltr">containers</bdi> בקבוצה חולקים <bdi dir="ltr">lifecycle</bdi> ו־<bdi dir="ltr">local network</bdi>; בדמו יש <bdi dir="ltr">container</bdi> אחד בלבד.
8. <bdi dir="ltr">Stop</bdi> ואז <bdi dir="ltr">Start</bdi> אם רוצים להמחיש <bdi dir="ltr">lifecycle</bdi>; המתינו ל־<bdi dir="ltr">Running</bdi> ובדקו שוב את <bdi dir="ltr">FQDN</bdi> מתוך <bdi dir="ltr">Overview.</bdi> אין להסתמך על <bdi dir="ltr">public IP</bdi> שנשאר קבוע, ואין <bdi dir="ltr">volume</bdi> עמיד.

**תוצאה ואימות:** <bdi dir="ltr">Running</bdi>, <bdi dir="ltr">welcome</bdi> דרך <bdi dir="ltr">HTTP</bdi> ו־<bdi dir="ltr">image</bdi> תואם. <bdi dir="ltr">Provisioning succeeded</bdi> בלי <bdi dir="ltr">state Running</bdi> אינו מספיק.

**תצפית הוראתית:** <bdi dir="ltr">container</bdi> קטן אינו <bdi dir="ltr">VM</bdi> מנוהלת עם <bdi dir="ltr">RDP. filesystem</bdi> מקומי יכול להיעלם; <bdi dir="ltr">public ACI</bdi> אינו <bdi dir="ltr">ingress HTTPS</bdi> אוטומטי.

**תקלות:** <bdi dir="ltr">ImagePullFailed</bdi> → <bdi dir="ltr">registry/image/network/service capacity</bdi>; <bdi dir="ltr">region quota</bdi>; <bdi dir="ltr">DNS label</bdi> תפוס; <bdi dir="ltr">protocol HTTPS</bdi> בטעות; <bdi dir="ltr">port</bdi> לא הוגדר. אין להשתמש ב־<bdi dir="ltr">image</bdi> פרטי או להדפיס <bdi dir="ltr">passwords</bdi> כדי לתקן.

**ניקוי:** מחקו <bdi dir="ltr">`az104-demo09-aci`</bdi> אחרי בדיקת <bdi dir="ltr">ownership. Stop</bdi> אינו ניקוי מלא ומשאבים נוספים, אם נוצרו, עלולים להישאר. אין לשמור <bdi dir="ltr">DNS name pointing</bdi> למשאב שנמחק.

## <bdi dir="ltr">4. Azure Container Apps</bdi> — <bdi dir="ltr">environment</bdi>, <bdi dir="ltr">ingress</bdi> ו־<bdi dir="ltr">revision</bdi>

**מטרה:** לבצע <bdi dir="ltr">demo</bdi> שקופית <bdi dir="ltr">32</bdi> ולהבדיל <bdi dir="ltr">ACA</bdi> מ־<bdi dir="ltr">ACI</bdi> בלי לפרוס <bdi dir="ltr">AKS.</bdi>

**דרישות ומשאבים:** <bdi dir="ltr">`az104-demo09-aca`</bdi>, <bdi dir="ltr">Contributor</bdi>, <bdi dir="ltr">Microsoft.App Registered</bdi>, <bdi dir="ltr">Consumption</bdi> זמין באזור. <bdi dir="ltr">App</bdi> <bdi dir="ltr">`aca-demo09`</bdi>, <bdi dir="ltr">environment</bdi> <bdi dir="ltr">`cae-demo09`</bdi>. אם <bdi dir="ltr">Logging</bdi> דורש <bdi dir="ltr">workspace</bdi>, צרו **חדש** <bdi dir="ltr">`law-demo09-aca`</bdi> בקבוצת <bdi dir="ltr">ACA</bdi>; אל תחברו <bdi dir="ltr">workspace</bdi> ארגוני.

### צעדים

1. <bdi dir="ltr">Container Apps > Create > Container App:</bdi> מנוי, קבוצת <bdi dir="ltr">ACA</bdi>, שם <bdi dir="ltr">`aca-demo09`</bdi>, <bdi dir="ltr">Deployment source Container image</bdi>; ללא <bdi dir="ltr">Optimize for Azure Functions.</bdi>
2. <bdi dir="ltr">Environment > Create new</bdi> <bdi dir="ltr">`cae-demo09`</bdi>, <bdi dir="ltr">West Europe</bdi>, <bdi dir="ltr">workload profile</bdi> **<bdi dir="ltr">Consumption</bdi>**, לא <bdi dir="ltr">Dedicated.</bdi> ללא <bdi dir="ltr">custom VNet</bdi>, <bdi dir="ltr">zone redundancy</bdi> או <bdi dir="ltr">public IP</bdi> עצמאי.
3. <bdi dir="ltr">Logging:</bdi> בחרו <bdi dir="ltr">None</bdi> אם הממשק מאפשר במסלול זה. אם לא, בחרו <bdi dir="ltr">Log Analytics</bdi> עם <bdi dir="ltr">Create new</bdi> <bdi dir="ltr">`law-demo09-aca`</bdi>; בדקו עלות <bdi dir="ltr">ingestion</bdi> ו־<bdi dir="ltr">retention</bdi> ברירת מחדל. <bdi dir="ltr">workspace</bdi> אינו חינמי ללא תנאי.
4. <bdi dir="ltr">Container ></bdi> **<bdi dir="ltr">Use quickstart image</bdi>**. רשמו את ה־<bdi dir="ltr">image</bdi> שמופיע בפועל; במסלול ידני השתמשו ב־<bdi dir="ltr">`mcr.microsoft.com/k8se/quickstart:latest`</bdi>, <bdi dir="ltr">registry</bdi> ציבורי ללא <bdi dir="ltr">authentication.</bdi>
5. <bdi dir="ltr">CPU</bdi> <bdi dir="ltr">`0.25`</bdi>, <bdi dir="ltr">Memory</bdi> <bdi dir="ltr">`0.5 GiB`</bdi> אם השילוב נתמך; <bdi dir="ltr">Ingress Enabled</bdi>, <bdi dir="ltr">external</bdi>, <bdi dir="ltr">HTTP</bdi>, <bdi dir="ltr">Target port</bdi> <bdi dir="ltr">`80`</bdi>. אין <bdi dir="ltr">Accept insecure connections</bdi> אם ניתן להשאיר כבוי; <bdi dir="ltr">endpoint</bdi> נבדק דרך <bdi dir="ltr">HTTPS.</bdi>
6. <bdi dir="ltr">Scaling: Min replicas</bdi> <bdi dir="ltr">`0`</bdi>, <bdi dir="ltr">Max replicas</bdi> <bdi dir="ltr">`1`</bdi>. אם שדה <bdi dir="ltr">Scaling</bdi> אינו באשף, הגדירו מיד לאחר היצירה ב־<bdi dir="ltr">Scale / Scale and replicas</bdi> לפני בדיקות חוזרות.
7. <bdi dir="ltr">Review + create:</bdi> בדקו <bdi dir="ltr">Consumption</bdi> ורשימת <bdi dir="ltr">workspace</bdi> נלווה, <bdi dir="ltr">Create.</bdi> המתינו ל־<bdi dir="ltr">Succeeded.</bdi>
8. <bdi dir="ltr">App > Overview > Application URL:</bdi> פתחו את הכתובת בפועל ב־<bdi dir="ltr">HTTPS.</bdi> הדף הצפוי הוא <bdi dir="ltr">welcome</bdi> של <bdi dir="ltr">quickstart.</bdi> התחלה מ־<bdi dir="ltr">0</bdi> עשויה לגרום <bdi dir="ltr">cold start</bdi>; רענון סביר עד שה־<bdi dir="ltr">revision Ready.</bdi>
9. <bdi dir="ltr">Revisions and replicas:</bdi> הראו <bdi dir="ltr">active revision</bdi> ואת מספר <bdi dir="ltr">replicas</bdi> בזמן בקשה. אין להבטיח ירידה מיידית לאפס; <bdi dir="ltr">scale-in</bdi> תלוי <bdi dir="ltr">cooldown</bdi> והיעדר תעבורה.
10. להדגמת <bdi dir="ltr">revision</bdi> חדשה, <bdi dir="ltr">Edit and deploy / Create new revision:</bdi> הוסיפו <bdi dir="ltr">environment variable</bdi> פיקטיבי <bdi dir="ltr">`DEMO_RELEASE=revision-b`</bdi>, <bdi dir="ltr">revision suffix</bdi> <bdi dir="ltr">`demob`</bdi>, בלי לשנות <bdi dir="ltr">image</bdi> או להוסיף <bdi dir="ltr">secret.</bdi>
11. <bdi dir="ltr">Deploy</bdi> במצב **<bdi dir="ltr">Single revision</bdi>**. לאחר <bdi dir="ltr">Ready</bdi> בדקו שה־<bdi dir="ltr">active revision</bdi> החדשה מופיעה וש־<bdi dir="ltr">Application URL</bdi> עדיין עובד. ערך הסביבה לא בהכרח מוצג בדף: האימות הוא תצורת <bdi dir="ltr">revision</bdi>, לא שינוי הודעת <bdi dir="ltr">welcome.</bdi>
12. הציגו אפשרות <bdi dir="ltr">Multiple revisions</bdi> ו־<bdi dir="ltr">traffic weights</bdi> לצפייה בלבד, בלי לשנות <bdi dir="ltr">routing.</bdi> בשקופית <bdi dir="ltr">45</bdi> הסבירו <bdi dir="ltr">sidecar/pod</bdi>; אין צורך להקים <bdi dir="ltr">cluster</bdi> כדי לצפות ב־<bdi dir="ltr">revision.</bdi>

**תוצאה ואימות:** <bdi dir="ltr">environment</bdi> נוצר, <bdi dir="ltr">app URL</bdi> עובד ב־<bdi dir="ltr">HTTPS</bdi>, <bdi dir="ltr">revision Ready</bdi> ו־<bdi dir="ltr">max replicas 1.</bdi> אין בדיקת <bdi dir="ltr">benchmark</bdi> או הוכחה שכל החיובים אפס ב־<bdi dir="ltr">scale-to-zero.</bdi>

**תצפית הוראתית:** <bdi dir="ltr">ACA</bdi> מנהל <bdi dir="ltr">ingress/scaling/revisions</bdi>; <bdi dir="ltr">ACI</bdi> מנהל <bdi dir="ltr">container group. Dedicated workload profile</bdi>, <bdi dir="ltr">logs</bdi> ונתונים נלווים יכולים להמשיך לחייב גם כשה־<bdi dir="ltr">app</bdi> אינה מריצה <bdi dir="ltr">replicas.</bdi>

**תקלות:** <bdi dir="ltr">Microsoft.App</bdi> לא <bdi dir="ltr">Registered</bdi>; <bdi dir="ltr">quota/region capacity</bdi>; <bdi dir="ltr">target port</bdi> שגוי; <bdi dir="ltr">revision Failed</bdi> בגלל <bdi dir="ltr">image</bdi> או <bdi dir="ltr">CPU/memory</bdi> לא תואמים. <bdi dir="ltr">Logs > System console/log stream</bdi> יכול לסייע, אך אין להציג <bdi dir="ltr">secret values</bdi> או להניח <bdi dir="ltr">logs</bdi> כבר הגיעו ל־<bdi dir="ltr">workspace.</bdi>

**ניקוי סופי:** מחקו <bdi dir="ltr">`az104-demo09-aca`</bdi> כולל <bdi dir="ltr">app</bdi>, <bdi dir="ltr">environment</bdi> ו־<bdi dir="ltr">workspace</bdi> ייעודי אם נוצר. בדקו גם <bdi dir="ltr">`az104-demo09-web`</bdi>: <bdi dir="ltr">plan</bdi> בתשלום נשאר מחויב בלי <bdi dir="ltr">apps. workspace soft delete/retention</bdi> עשויים להשאיר נתונים לזמן מה; אין לבצע <bdi dir="ltr">purge.</bdi> אין למחוק <bdi dir="ltr">environment</bdi> משותף או <bdi dir="ltr">workspace</bdi> שלא נוצר בדמו.

## מקורות <bdi dir="ltr">Microsoft</bdi>

- <span dir="ltr">[App Service plans](https://learn.microsoft.com/azure/app-service/overview-hosting-plans)</span>
- <span dir="ltr">[Deployment slots](https://learn.microsoft.com/azure/app-service/deploy-staging-slots)</span>
- <span dir="ltr">[Scale up](https://learn.microsoft.com/azure/app-service/manage-scale-up)</span>
- <span dir="ltr">[Automatic scaling](https://learn.microsoft.com/azure/app-service/manage-automatic-scaling)</span>
- <span dir="ltr">[ACI portal quickstart](https://learn.microsoft.com/azure/container-instances/container-instances-quickstart-portal)</span>
- <span dir="ltr">[ACA portal quickstart](https://learn.microsoft.com/azure/container-apps/quickstart-portal)</span>
- <span dir="ltr">[ACA revisions](https://learn.microsoft.com/azure/container-apps/revisions)</span>
- <span dir="ltr">[ACA scaling](https://learn.microsoft.com/azure/container-apps/scale-app)</span>
- [השוואת פתרונות <bdi dir="ltr">containers</bdi>](https://learn.microsoft.com/azure/container-apps/compare-options)

</div>
