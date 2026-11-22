<div dir="rtl" align="right">

# מודול <bdi dir="ltr">07</bdi> — הדגמות <bdi dir="ltr">Azure Storage</bdi>

מדריך מלווה נוסף למרצה עבור [המצגת](AZ-104T00A-ENU-PowerPoint_07.pptx); הוא אינו משנה חומרים קיימים. ארבע הדגמות משתמשות בחשבון קטן יחיד ובנתוני טקסט פיקטיביים. <bdi dir="ltr">SAS</bdi> נלמד באמצעות סקירת שדות בלבד: אין לייצר, להעתיק או להציג <bdi dir="ltr">token</bdi> אמיתי.

## מפת ההדגמות

| הדגמה | שקופיות | זמן משוער |
| ---: | ---: | ---: |
| <bdi dir="ltr">1.</bdi> חשבון <bdi dir="ltr">Storage</bdi>, <bdi dir="ltr">redundancy</bdi> ו־<bdi dir="ltr">firewall</bdi> | <span dir="ltr">7–13, 46–47</span> | <bdi dir="ltr">20</bdi> דקות |
| <bdi dir="ltr">2. Container</bdi>, גרסאות ו־<bdi dir="ltr">lifecycle</bdi> | <span dir="ltr">17–22</span> | <bdi dir="ltr">25</bdi> דקות |
| <bdi dir="ltr">3. RBAC</bdi>, הצפנה ותכנון <bdi dir="ltr">SAS</bdi> בטוח | <span dir="ltr">27–33</span> | <bdi dir="ltr">15</bdi> דקות |
| <bdi dir="ltr">4. Azure Files</bdi>, <bdi dir="ltr">snapshot</bdi> ו־<bdi dir="ltr">soft delete</bdi> | <span dir="ltr">38–43</span> | <bdi dir="ltr">25</bdi> דקות |

## הכנה משותפת

1. ב־<bdi dir="ltr">Azure portal > Settings > Directories + subscriptions</bdi> אמתו <bdi dir="ltr">Tenant</bdi> ו־<bdi dir="ltr">Subscription ID.</bdi> בחרו אותו מנוי בכל יצירה; אין להסתמך על מנוי ברירת מחדל.
2. צרו קבוצת משאבים חדשה <bdi dir="ltr">`az104-demo07`</bdi> ב־<bdi dir="ltr">West Europe</bdi> ותג <bdi dir="ltr">`Purpose=ClassroomDemo`</bdi>. שם חשבון לדוגמה: <bdi dir="ltr">`az104d07store261122`</bdi>; הוא חייב להיות ייחודי גלובלית, <bdi dir="ltr">3</bdi>–<bdi dir="ltr">24</bdi> תווים, אותיות קטנות וספרות. אם תפוס, החליפו רק את סיומת הספרות ורשמו את השם בפועל.
3. להקמה: <bdi dir="ltr">Contributor</bdi> בקבוצה. להקצאת תפקידים: <bdi dir="ltr">Owner</bdi> או <bdi dir="ltr">Role Based Access Control Administrator</bdi> בסקופ המתאים. לביצוע <bdi dir="ltr">Blob data operations</bdi> דרוש <bdi dir="ltr">`Storage Blob Data Contributor`</bdi>; ל־<bdi dir="ltr">Azure Files</bdi> בפורטל דרך <bdi dir="ltr">Entra</bdi> דרוש <bdi dir="ltr">`Storage File Data Privileged Contributor`</bdi> וגם הרשאת <bdi dir="ltr">Reader</bdi> למשאב. תפקיד <bdi dir="ltr">Contributor</bdi> לניהול אינו תפקיד <bdi dir="ltr">data.</bdi>
4. בעל הרשאה יקצה למרצה את שני תפקידי הנתונים **בסקופ חשבון הדמו בלבד**, ב־<bdi dir="ltr">Access control</bdi> (<bdi dir="ltr">IAM</bdi>) > <bdi dir="ltr">Add role assignment > User > Select member > Review + assign.</bdi> המתינו להפצת <bdi dir="ltr">RBAC</bdi>, לעיתים עד <bdi dir="ltr">30</bdi> דקות, ורעננו את ההתחברות. אין להרחיב הרשאה לכל המנוי כדי לפתור <bdi dir="ltr">403.</bdi>
5. ב־<bdi dir="ltr">Notepad</bdi> צרו בתוך תיקיית עבודה שלכם <bdi dir="ltr">`demo07.txt`</bdi> עם <bdi dir="ltr">`Demo version 1`</bdi>. זהו תוכן הדגמה, לא מידע אישי. אין לפתוח <bdi dir="ltr">Access keys</bdi> או <bdi dir="ltr">connection strings.</bdi> כשנכנסים ל־<bdi dir="ltr">Storage browser</bdi> בחרו **<bdi dir="ltr">Authentication method: Microsoft Entra user account</bdi>** לפני פעולות נתונים; אם הממשק מציג <bdi dir="ltr">Access key</bdi>, החליפו שיטה בלי להציג או לקבל <bdi dir="ltr">keys.</bdi>

## <bdi dir="ltr">1.</bdi> חשבון <bdi dir="ltr">Storage</bdi>, <bdi dir="ltr">redundancy</bdi> ו־<bdi dir="ltr">firewall</bdi>

**מטרה:** ליצור <bdi dir="ltr">StorageV2</bdi> ולהראות את ההפרדה בין זמינות הנתונים, הרשאה אליהם ונתיב הרשת.

**דרישות ומשאבים:** ההכנה המשותפת; חשבון יחיד <bdi dir="ltr">`az104d07store261122`</bdi> בקבוצת הדמו. עלות <bdi dir="ltr">LRS</bdi> קטנה אך אינה אפס. אין <bdi dir="ltr">Premium</bdi>, <bdi dir="ltr">geo-replication</bdi> או <bdi dir="ltr">private endpoint</bdi> בדמו הבסיסי.

### צעדים

1. <bdi dir="ltr">Storage accounts > Create:</bdi> המנוי המאומת, <bdi dir="ltr">`az104-demo07`</bdi>, השם הייחודי, <bdi dir="ltr">West Europe</bdi>, <bdi dir="ltr">Performance Standard</bdi>, <bdi dir="ltr">Redundancy LRS.</bdi>
2. ב־<bdi dir="ltr">Advanced</bdi> השאירו <bdi dir="ltr">Secure transfer required</bdi> פעיל ו־<bdi dir="ltr">Minimum TLS version</bdi> = <bdi dir="ltr">1.2</bdi>; השביתו <bdi dir="ltr">Allow anonymous access.</bdi> ללא <bdi dir="ltr">hierarchical namespace</bdi> כדי לאפשר <bdi dir="ltr">Blob versioning.</bdi>
3. בחרו <bdi dir="ltr">default access tier Hot.</bdi> במסלול שאינו כולל <bdi dir="ltr">Azure Files Backup</bdi> אפשר להשבית **<bdi dir="ltr">Allow storage account key access</bdi>**; השתמשו ב־<bdi dir="ltr">Entra.</bdi> אין להעתיק את ההגדרה אוטומטית לסביבת <bdi dir="ltr">Backup</bdi> של מודול <bdi dir="ltr">10.</bdi>
4. ב־<bdi dir="ltr">Networking</bdi> בחרו <bdi dir="ltr">public endpoint</bdi> עם **<bdi dir="ltr">Enabled from selected virtual networks and IP addresses</bdi>**, ובחרו <bdi dir="ltr">Add your client IP address.</bdi> ודאו שזו כתובת ה־<bdi dir="ltr">egress</bdi> המאושרת של המחשב שמריץ את הפורטל. אין צורך ב־<bdi dir="ltr">VNet</bdi> לשיטת <bdi dir="ltr">IP</bdi> זו. אם האשף מאפשר רק <bdi dir="ltr">All networks</bdi>, אחרי היצירה הגבילו מיד ב־<bdi dir="ltr">Networking</bdi> לפני העלאת נתונים.
5. ב־<bdi dir="ltr">Data protection</bdi> הפעילו <bdi dir="ltr">Blob soft delete</bdi>, <bdi dir="ltr">Container soft delete</bdi> ו־<bdi dir="ltr">File share soft delete</bdi> למשך <bdi dir="ltr">`7`</bdi> ימים; הפעילו <bdi dir="ltr">Blob versioning.</bdi> אין להפעיל <bdi dir="ltr">immutability</bdi>, <bdi dir="ltr">point-in-time restore</bdi> או <bdi dir="ltr">object replication</bdi> לצורך דמו זה.
6. <bdi dir="ltr">Review + create:</bdi> בדקו <bdi dir="ltr">LRS</bdi>, <bdi dir="ltr">region</bdi> ושם. <bdi dir="ltr">Create</bdi>, והמתינו ל־<bdi dir="ltr">Succeeded.</bdi>
7. <bdi dir="ltr">Overview / Endpoints:</bdi> הציגו את סיומות <bdi dir="ltr">Blob</bdi> ו־<bdi dir="ltr">File</bdi>, שאינן סוד. <bdi dir="ltr">Configuration / Encryption: Microsoft-managed keys</bdi>; ההצפנה במנוחה קיימת כברירת מחדל.
8. ב־<bdi dir="ltr">Data management > Redundancy</bdi> הציגו את הבחירות הנתמכות, בלי לשמור שינוי. הסבירו <bdi dir="ltr">LRS</bdi> לעומת <bdi dir="ltr">ZRS</bdi> ו־<bdi dir="ltr">GRS/GZRS: copy</bdi> לאזור המשני הוא <bdi dir="ltr">asynchronous</bdi>; אין לבצע <bdi dir="ltr">failover.</bdi>
9. <bdi dir="ltr">Networking:</bdi> הציגו <bdi dir="ltr">selected networks</bdi> ואת כלל <bdi dir="ltr">IP</bdi> שלכם. אל תמחקו אותו בזמן העבודה. תלמיד עם מחשב ב־<bdi dir="ltr">egress</bdi> אחר יכול לבדוק <bdi dir="ltr">URL</bdi> של <bdi dir="ltr">blob</bdi> פרטי אחרי הדגמה <bdi dir="ltr">2</bdi>; כשל בלי זהות אינו הוכחת <bdi dir="ltr">firewall</bdi> לבדו.

**תוצאה ואימות:** <bdi dir="ltr">Overview</bdi> מציג <bdi dir="ltr">StorageV2</bdi> ו־<bdi dir="ltr">LRS</bdi>; <bdi dir="ltr">Configuration</bdi> מציג <bdi dir="ltr">TLS/HTTPS</bdi> ואיסור <bdi dir="ltr">anonymous access.</bdi> פתיחת <bdi dir="ltr">Storage browser</bdi> עם <bdi dir="ltr">Entra</bdi> אמורה להצליח רק עם <bdi dir="ltr">data role</bdi> ונתיב רשת מורשה.

**תצפית הוראתית:** שלושה <bdi dir="ltr">replicas</bdi> אינם <bdi dir="ltr">backup</bdi> למחיקה לוגית. <bdi dir="ltr">geo-redundancy</bdi> אינה מבטיחה אפס <bdi dir="ltr">RPO</bdi>, ו־<bdi dir="ltr">RA</bdi> מוסיף <bdi dir="ltr">read access</bdi> למשני, לא כתיבה.

**תקלות:** שם תפוס; <bdi dir="ltr">region/SKU</bdi> שנחסמו ב־<bdi dir="ltr">Policy</bdi>; <bdi dir="ltr">IP</bdi> של <bdi dir="ltr">VPN</bdi> שונה; <bdi dir="ltr">proxy</bdi> שמוציא דרך כתובת אחרת; <bdi dir="ltr">RBAC</bdi> טרם הופץ. אם מדיניות דורשת <bdi dir="ltr">Private Link</bdi>, אין לעקוף אותה: הציגו את אשף התצורה בלבד או השתמשו בסביבה פרטית שהוכנה ואושרה מראש.

**ניקוי:** אין למחוק את החשבון לפני הדגמות <bdi dir="ltr">2</bdi>–<bdi dir="ltr">4.</bdi> בסוף מחקו רק את קבוצת הדמו לאחר רשימת משאבים; לא מבצעים שינוי <bdi dir="ltr">redundancy</bdi> או <bdi dir="ltr">failover</bdi> לצורך ניקוי.

## <bdi dir="ltr">2. Blob Container</bdi>, גרסאות ו־<bdi dir="ltr">lifecycle</bdi>

**מטרה:** להדגים את <bdi dir="ltr">demo</bdi> שקופית <bdi dir="ltr">22</bdi> ולהוסיף התאוששות מ־<bdi dir="ltr">overwrite</bdi> וכלל <bdi dir="ltr">lifecycle</bdi> ממוקד, בלי להעביר נתונים ל־<bdi dir="ltr">Archive.</bdi>

**דרישות ומשאבים:** חשבון מהדגמה <bdi dir="ltr">1</bdi>, <bdi dir="ltr">`Storage Blob Data Contributor`</bdi>, קובץ <bdi dir="ltr">`demo07.txt`</bdi>. <bdi dir="ltr">Container</bdi> פרטי <bdi dir="ltr">`classroom`</bdi>, <bdi dir="ltr">blob</bdi> <bdi dir="ltr">`demo07.txt`</bdi>. <bdi dir="ltr">Versioning</bdi> מופעל וללא <bdi dir="ltr">HNS.</bdi>

### צעדים

1. <bdi dir="ltr">Storage account > Data storage > Containers > + Container:</bdi> שם <bdi dir="ltr">`classroom`</bdi>, <bdi dir="ltr">Public access level</bdi> **<bdi dir="ltr">Private</bdi>**. <bdi dir="ltr">Create.</bdi>
2. פתחו את ה־<bdi dir="ltr">container</bdi>, בחרו <bdi dir="ltr">authentication</bdi> באמצעות <bdi dir="ltr">Microsoft Entra. Upload ></bdi> קובץ <bdi dir="ltr">`demo07.txt`</bdi> > <bdi dir="ltr">Blob type Block blob > Hot > Upload.</bdi>
3. פתחו את <bdi dir="ltr">blob > Overview</bdi>; הציגו <bdi dir="ltr">Content length</bdi>, <bdi dir="ltr">Last modified</bdi>, <bdi dir="ltr">Access tier</bdi> ו־<bdi dir="ltr">URL.</bdi> הורידו את הקובץ באמצעות הפורטל המאומת ואמתו <bdi dir="ltr">`Demo version 1`</bdi>.
4. פתחו את <bdi dir="ltr">URL</bdi> ללא <bdi dir="ltr">SAS</bdi> בחלון <bdi dir="ltr">InPrivate.</bdi> הוא לא אמור להחזיר את התוכן הפרטי. ייתכנו <bdi dir="ltr">401/403/404</bdi> בהתאם לנתיב; אין להסיק מ־<bdi dir="ltr">404</bdi> בלבד שה־<bdi dir="ltr">blob</bdi> חסר.
5. שנו מקומית ל־<bdi dir="ltr">`Demo version 2`</bdi>, העלו שוב באותו שם עם <bdi dir="ltr">Overwrite.</bdi> פתחו <bdi dir="ltr">Versions</bdi>; אמורות להיות גרסה נוכחית וגרסה קודמת. הורידו את הגרסה הקודמת ואמתו את התוכן הראשון.
6. אם מוצגת פעולת **<bdi dir="ltr">Make current version</bdi>**, הפעילו אותה על הגרסה הראשונה של הדמו בלבד. הורידו שוב את ה־<bdi dir="ltr">blob</bdi> הנוכחי ואמתו <bdi dir="ltr">`Demo version 1`</bdi>. אם הפעולה לא זמינה, הסתפקו בהורדת הגרסה — אל תעתיקו באמצעות <bdi dir="ltr">SAS.</bdi>
7. ב־<bdi dir="ltr">Change tier</bdi> הציגו <bdi dir="ltr">Hot</bdi>, <bdi dir="ltr">Cool</bdi>, <bdi dir="ltr">Cold</bdi> ו־<bdi dir="ltr">Archive</bdi>; **<bdi dir="ltr">Cancel</bdi>**. הסבירו תקופות מינימום/<bdi dir="ltr">early deletion charges: Cool 30</bdi>, <bdi dir="ltr">Cold 90</bdi>, <bdi dir="ltr">Archive 180</bdi> ימים. <bdi dir="ltr">Rehydration</bdi> מ־<bdi dir="ltr">Archive</bdi> עשוי לקחת שעות ואינו דמו מיידי.
8. חשבון > <bdi dir="ltr">Data management > Lifecycle management > Add a rule:</bdi> שם <bdi dir="ltr">`demo07-cool-after30`</bdi>, <bdi dir="ltr">scope</bdi> **<bdi dir="ltr">Limit blobs with filters</bdi>**, <bdi dir="ltr">type Block blobs.</bdi>
9. <bdi dir="ltr">Base blobs: Last modified more than</bdi> <bdi dir="ltr">`30`</bdi> <bdi dir="ltr">days</bdi> → <bdi dir="ltr">Move to cool storage. Filter prefix</bdi> <bdi dir="ltr">`classroom/`</bdi>. ללא פעולת <bdi dir="ltr">Delete</bdi> וללא חוקים על <bdi dir="ltr">versions/snapshots. Review > Add.</bdi>
10. פתחו <bdi dir="ltr">Code view</bdi> של <bdi dir="ltr">policy</bdi> ואמתו שה־<bdi dir="ltr">prefix</bdi> הוא <bdi dir="ltr">`classroom/`</bdi> בלבד. ה־<bdi dir="ltr">blob</bdi> של היום אמור להישאר <bdi dir="ltr">Hot.</bdi> השביתו את הכלל לאחר סקירתו כדי שלא יפעל בהמשך על נתונים שנשארו.
11. לסקירת <bdi dir="ltr">Object replication</bdi> בשקופית <bdi dir="ltr">21</bdi> פתחו את הלהב בלי ליצור <bdi dir="ltr">policy.</bdi> הסבירו: נדרשים שני חשבונות נתמכים, <bdi dir="ltr">containers</bdi>, <bdi dir="ltr">versioning</bdi> בשניהם ו־<bdi dir="ltr">change feed</bdi> במקור; אין יעד שנוצר בהדגמה זו.

**תוצאה ואימות:** יש <bdi dir="ltr">blob</bdi> פרטי עם שתי גרסאות לפחות ו־<bdi dir="ltr">policy</bdi> ממוקד שהושבת. <bdi dir="ltr">Versions</bdi> מוכיחים <bdi dir="ltr">overwrite history.</bdi> מדיניות אינה הוכחה שבוצע <bdi dir="ltr">tiering:</bdi> תחילת עיבוד יכולה להתעכב עד <bdi dir="ltr">24</bdi> שעות, והשלמת סריקה יכולה להתארך.

**תצפית הוראתית:** <bdi dir="ltr">soft delete</bdi>, <bdi dir="ltr">versioning</bdi> ו־<bdi dir="ltr">replication</bdi> אינם אותו מנגנון. <bdi dir="ltr">overwrite</bdi> יוצר גרסה; <bdi dir="ltr">replication asynchronous</bdi> מעתיק שינויים, ו־<bdi dir="ltr">lifecycle</bdi> מתייחס לתנאים לאורך זמן.

**תקלות:** <bdi dir="ltr">403</bdi> → בדקו <bdi dir="ltr">Entra/data role</bdi> וגם <bdi dir="ltr">firewall.</bdi> אין <bdi dir="ltr">Versions</bdi> → ודאו שההפעלה הייתה לפני <bdi dir="ltr">overwrite</bdi> וש־<bdi dir="ltr">HNS</bdi> כבוי. <bdi dir="ltr">Prefix</bdi> חייב לכלול את שם ה־<bdi dir="ltr">container</bdi>, לא רק שם קובץ.

**ניקוי:** השביתו ואז מחקו רק <bdi dir="ltr">`demo07-cool-after30`</bdi>; ריצה שכבר התחילה עשויה להימשך. בסוף הדגמות מחקו <bdi dir="ltr">blobs/versions</bdi> ו־<bdi dir="ltr">container</bdi> של הדמו או את חשבון הדמו כולו לפי אישור. <bdi dir="ltr">soft delete</bdi> משאיר נתונים וחיובים בזמן <bdi dir="ltr">retention</bdi>; אין להשבית הגנה כדי לזרז מחיקה. <bdi dir="ltr">Immutability</bdi>, אם הופעלה מחוץ למסלול, יכולה למנוע מחיקה עד פקיעת <bdi dir="ltr">policy.</bdi>

## <bdi dir="ltr">3. Storage Security</bdi> — <bdi dir="ltr">RBAC</bdi> ותכנון <bdi dir="ltr">SAS</bdi> ללא סוד

**מטרה:** ללמד את שקופית <bdi dir="ltr">30</bdi> בלי להציג <bdi dir="ltr">signed URL.</bdi> משווים הרשאת זהות ל־<bdi dir="ltr">delegated access</bdi> ואת <bdi dir="ltr">SSE</bdi> ל־<bdi dir="ltr">CMK.</bdi>

**דרישות ומשאבים:** חשבון ו־<bdi dir="ltr">blob</bdi> מהדגמות <bdi dir="ltr">1</bdi>–<bdi dir="ltr">2</bdi>; <bdi dir="ltr">Reader</bdi> לניהול ו־<bdi dir="ltr">Blob data role.</bdi> אין ליצור <bdi dir="ltr">Key Vault</bdi> או <bdi dir="ltr">SAS.</bdi>

### צעדים

1. חשבון > <bdi dir="ltr">IAM > View my access:</bdi> הראו <bdi dir="ltr">Contributor/Reader</bdi> לניהול ותפקיד <bdi dir="ltr">Blob data</bdi> נפרד. בדקו שה־<bdi dir="ltr">scope</bdi> הוא חשבון הדמו ולא המנוי.
2. חזרו ל־<bdi dir="ltr">container</bdi> <bdi dir="ltr">`classroom`</bdi>; בחרו <bdi dir="ltr">Entra</bdi> ופתחו <bdi dir="ltr">Properties</bdi> של <bdi dir="ltr">`demo07.txt`</bdi>. הראו שהגישה עובדת בלי <bdi dir="ltr">URL</bdi> עם <bdi dir="ltr">`sig`</bdi>.
3. ב־<bdi dir="ltr">blob</bdi> פתחו **<bdi dir="ltr">Generate SAS</bdi>** אם מוצג. אל תלחצו <bdi dir="ltr">Generate.</bdi> אם <bdi dir="ltr">key access disabled</bdi> מונע פתיחת האשף, זו הגנה צפויה; אל תפעילו <bdi dir="ltr">shared key</bdi> כדי להמשיך.
4. הציגו רק את השדות: <bdi dir="ltr">signing method</bdi> **<bdi dir="ltr">User delegation key</bdi>** באמצעות <bdi dir="ltr">Entra</bdi>, <bdi dir="ltr">permission</bdi> **<bdi dir="ltr">Read</bdi> בלבד**, <bdi dir="ltr">HTTPS only</bdi>, <bdi dir="ltr">expiry</bdi> קצר של כ־<bdi dir="ltr">10</bdi> דקות, <bdi dir="ltr">scope</bdi> ל־<bdi dir="ltr">blob</bdi> יחיד. אין לבחור <bdi dir="ltr">Write/Delete/List</bdi> לצורך קריאת <bdi dir="ltr">blob.</bdi>
5. אם נדרש <bdi dir="ltr">start time</bdi>, הסבירו <bdi dir="ltr">clock skew</bdi>; בתכנון אפשר להשאיר <bdi dir="ltr">start time</bdi> ללא הגבלה התחלתית אם השירות מאפשר. <bdi dir="ltr">IP restriction</bdi> מתייחס ל־<bdi dir="ltr">egress</bdi> הציבורי האמיתי, לא ל־<bdi dir="ltr">IP</bdi> פרטי של לקוח.
6. כתבו על הלוח שמות פרמטרים בלבד: <bdi dir="ltr">`sp`</bdi>, <bdi dir="ltr">`se`</bdi>, <bdi dir="ltr">`spr`</bdi>, <bdi dir="ltr">`sr`</bdi>, <bdi dir="ltr">`sig`</bdi>; **לא** <bdi dir="ltr">signed URI</bdi>, <bdi dir="ltr">token</bdi> או ערך <bdi dir="ltr">signature.</bdi> סגרו את האשף.
7. <bdi dir="ltr">Encryption:</bdi> ודאו <bdi dir="ltr">Microsoft-managed keys.</bdi> פתחו בחירת <bdi dir="ltr">Customer-managed keys</bdi> לצפייה בלבד: נדרשים <bdi dir="ltr">Key Vault/Managed HSM</bdi>, <bdi dir="ltr">managed identity</bdi> והרשאות <bdi dir="ltr">key</bdi>; אל תבחרו משאב ארגוני ואל תשמרו.
8. שאלו: האם <bdi dir="ltr">URL</bdi> פרטי ללא <bdi dir="ltr">token</bdi> אמור לעבוד בחלון אנונימי? לא. האם <bdi dir="ltr">SAS</bdi> עוקף <bdi dir="ltr">firewall</bdi>? לא. האם <bdi dir="ltr">stored access policy</bdi> חלה על כל סוג <bdi dir="ltr">SAS</bdi>? לא; היא קשורה ל־<bdi dir="ltr">service SAS</bdi>, ולא ל־<bdi dir="ltr">account/user delegation SAS.</bdi>

**תוצאה ואימות:** <bdi dir="ltr">authentication</bdi> בפורטל נשאר <bdi dir="ltr">Entra</bdi>; אין <bdi dir="ltr">token</bdi> שנוצר, אין <bdi dir="ltr">key</bdi> שהתקבל ואין <bdi dir="ltr">CMK</bdi> שהוחלף. בדיקת <bdi dir="ltr">delegated SAS</bdi> בפועל היא **מחוץ למסלול**, לא תוצאה שהושגה.

**תצפית הוראתית:** <bdi dir="ltr">SAS</bdi> הוא <bdi dir="ltr">bearer credential</bdi> אפילו אם תקף לזמן קצר. לא מצרפים אותו ל־<bdi dir="ltr">chat</bdi>, צילום מסך, שקופית, <bdi dir="ltr">shell history</bdi> או <bdi dir="ltr">repository.</bdi>

**תקלות:** <bdi dir="ltr">User delegation signing</bdi> דורש הרשאת <bdi dir="ltr">generateUserDelegationKey</bdi> בסקופ חשבון ומעלה; <bdi dir="ltr">role</bdi> על <bdi dir="ltr">container</bdi> בלבד אינו בהכרח מספיק. אין לפתור זאת באמצעות קבלת <bdi dir="ltr">account key.</bdi> ב־<bdi dir="ltr">CMK</bdi> טעות בהרשאות/זמינות <bdi dir="ltr">key</bdi> יכולה לחסום נתונים — לכן סקירה בלבד.

**ניקוי:** סגרו טיוטות. אל תסירו <bdi dir="ltr">data roles</bdi> לפני הדגמה <bdi dir="ltr">4.</bdi> אם הייתה הקצאת <bdi dir="ltr">role</bdi> ייעודית לדמו, הסירו רק אותה לאחר סיום, בלי לשנות <bdi dir="ltr">role assignments</bdi> קיימים.

## <bdi dir="ltr">4. Azure Files</bdi> — קובץ, <bdi dir="ltr">snapshot</bdi> ו־<bdi dir="ltr">soft delete</bdi>

**מטרה:** לבצע את <bdi dir="ltr">demo</bdi> שקופית <bdi dir="ltr">43</bdi> דרך הפורטל, בלי <bdi dir="ltr">mount</bdi> עם <bdi dir="ltr">account key</bdi> ובלי לפרוס <bdi dir="ltr">Domain Services</bdi> או <bdi dir="ltr">File Sync.</bdi>

**דרישות ומשאבים:** חשבון מהדגמה <bdi dir="ltr">1</bdi>, <bdi dir="ltr">`Storage File Data Privileged Contributor`</bdi> ו־<bdi dir="ltr">Reader</bdi> בסקופ החשבון, נתיב <bdi dir="ltr">firewall</bdi> מורשה. <bdi dir="ltr">Share SMB</bdi> בשם <bdi dir="ltr">`demo-share`</bdi>, <bdi dir="ltr">standard pay-as-you-go / transaction optimized</bdi> כשזמין, <bdi dir="ltr">quota</bdi> <bdi dir="ltr">`5 GiB`</bdi> אם המודל מאפשר. אם האזור מציע רק מודל <bdi dir="ltr">provisioned</bdi> עם מינימום יקר, סקרו את האשף בלי <bdi dir="ltr">Create.</bdi>

### צעדים

1. חשבון > <bdi dir="ltr">Data storage > File shares / Classic file shares > + File share:</bdi> <bdi dir="ltr">`demo-share`</bdi>, <bdi dir="ltr">SMB</bdi>, <bdi dir="ltr">tier Transaction optimized</bdi> במסלול <bdi dir="ltr">Standard</bdi>, <bdi dir="ltr">quota</bdi> <bdi dir="ltr">`5 GiB`</bdi>. בחרו את הגודל המינימלי המאושר; אין <bdi dir="ltr">Premium/NFS.</bdi>
2. פתחו <bdi dir="ltr">Browse</bdi> ובחרו **<bdi dir="ltr">Microsoft Entra user account</bdi>**. העלו <bdi dir="ltr">`demo07.txt`</bdi> עם תוכן <bdi dir="ltr">`Files version 1`</bdi>. הורידו ואמתו את הטקסט.
3. <bdi dir="ltr">Snapshots > Add snapshot / Create snapshot.</bdi> רשמו את <bdi dir="ltr">timestamp. Snapshot</bdi> הוא <bdi dir="ltr">read-only</bdi> בנקודת זמן.
4. שנו את הקובץ המקומי ל־<bdi dir="ltr">`Files version 2`</bdi>, העלו באותו שם ו־<bdi dir="ltr">Overwrite.</bdi>
5. פתחו את <bdi dir="ltr">snapshot > Browse ></bdi> בחרו <bdi dir="ltr">`demo07.txt`</bdi>; הורידו את העותק ואמתו <bdi dir="ltr">`Files version 1`</bdi>. לשחזור בטוח העלו אותו ל־<bdi dir="ltr">share</bdi> החי בשם <bdi dir="ltr">`demo07-restored.txt`</bdi>, במקום לדרוס את הגרסה השנייה.
6. חזרו לרשימת <bdi dir="ltr">shares > Soft delete / Manage soft delete.</bdi> ודאו <bdi dir="ltr">Enabled</bdi> ו־<bdi dir="ltr">`7`</bdi> ימים מהדגמה <bdi dir="ltr">1.</bdi> המחיקה הרכה מגינה על **<bdi dir="ltr">share</bdi> שנמחק**, לא על כל מחיקת קובץ בודד.
7. לאחר אימות <bdi dir="ltr">snapshot</bdi>, מחקו **רק** <bdi dir="ltr">`demo-share`</bdi>, בלי לשנות <bdi dir="ltr">retention.</bdi> הפעילו <bdi dir="ltr">Show deleted shares</bdi>, בחרו את <bdi dir="ltr">share</bdi> הדמו > <bdi dir="ltr">Undelete.</bdi> חזרו ל־<bdi dir="ltr">Browse</bdi> ואמתו שהקבצים וה־<bdi dir="ltr">snapshot</bdi> חזרו.
8. פתחו <bdi dir="ltr">Connect</bdi> לצפייה בהסבר <bdi dir="ltr">SMB</bdi> בלבד; אל תציגו או תעתיקו <bdi dir="ltr">script</bdi> שמכיל <bdi dir="ltr">key. TCP 445</bdi> נדרש ל־<bdi dir="ltr">SMB</bdi>; גישה דרך הפורטל/<bdi dir="ltr">OAuth over REST</bdi> אינה הוכחה ש־<bdi dir="ltr">SMB</bdi> פתוח מהמחשב.
9. <bdi dir="ltr">Storage browser</bdi> הוא חלופה בתוך הפורטל. <bdi dir="ltr">Storage Explorer</bdi> חיצוני אופציונלי: התחברות באמצעות <bdi dir="ltr">Entra</bdi> בלבד ותמיכת הרשאות לפי השירות; אין צורך להתקין אותו בשיעור.

**תוצאה ואימות:** הקובץ החי <bdi dir="ltr">version 2</bdi>, העותק מה־<bdi dir="ltr">snapshot version 1</bdi>, ולאחר <bdi dir="ltr">Undelete</bdi> ה־<bdi dir="ltr">share</bdi> שוב פעיל. אין <bdi dir="ltr">SMB session</bdi> או <bdi dir="ltr">File Sync</bdi> פעילים.

**תצפית הוראתית:** <bdi dir="ltr">share snapshot</bdi> אינו <bdi dir="ltr">blob version. File share soft delete</bdi> אינו <bdi dir="ltr">file-level recycle bin. NFS</bdi> אינו מסלול ההדגמה; אין להחיל עליו אוטומטית את התנהגות <bdi dir="ltr">SMB.</bdi>

**תקלות:** <bdi dir="ltr">403</bdi> בפורטל → <bdi dir="ltr">Privileged data role</bdi> ולא <bdi dir="ltr">SMB Share Contributor</bdi> בלבד; ודאו <bdi dir="ltr">authentication Entra. Undelete</bdi> לא מופיע → הציגו <bdi dir="ltr">deleted shares</bdi> והמתינו לרענון; בדקו שהמחיקה נעשתה לאחר הפעלת <bdi dir="ltr">soft delete. mount</bdi> נכשל ב־<bdi dir="ltr">445</bdi> → מגבלת רשת, לא תקלה ב־<bdi dir="ltr">snapshot.</bdi>

**ניקוי סופי:** מחקו <bdi dir="ltr">snapshot</bdi> וקבצי דמו בלבד; מחיקת <bdi dir="ltr">share</bdi> תעביר אותו שוב ל־<bdi dir="ltr">soft-deleted state.</bdi> אין <bdi dir="ltr">purge</bdi> ואין ביטול <bdi dir="ltr">protection.</bdi> למחיקת חשבון הדמו כולו, בדקו שאין <bdi dir="ltr">backup enrollment/lock</bdi> ושהוא מכיל רק נתוני דמו; מחיקת החשבון אינה דרך לשחזור <bdi dir="ltr">share.</bdi> אם <bdi dir="ltr">protection</bdi> או <bdi dir="ltr">policy</bdi> מונעים מחיקה, השאירו תחת <bdi dir="ltr">retention</bdi> ותעדו מועד בדיקה חוזרת.

## מקורות <bdi dir="ltr">Microsoft</bdi>

- [יצירת <bdi dir="ltr">Storage account</bdi>](https://learn.microsoft.com/azure/storage/common/storage-account-create)
- <span dir="ltr">[Redundancy](https://learn.microsoft.com/azure/storage/common/storage-redundancy)</span>
- <span dir="ltr">[Storage network security](https://learn.microsoft.com/azure/storage/common/storage-network-security)</span>
- <span dir="ltr">[Access tiers](https://learn.microsoft.com/azure/storage/blobs/access-tiers-overview)</span>
- [<bdi dir="ltr">Lifecycle management</bdi> ומחזורי עיבוד](https://learn.microsoft.com/azure/storage/blobs/lifecycle-management-overview)
- <span dir="ltr">[SAS overview](https://learn.microsoft.com/azure/storage/common/storage-sas-overview)</span>
- [הרשאות <bdi dir="ltr">Azure Files</bdi> בפורטל](https://learn.microsoft.com/azure/storage/files/authorize-data-operations-portal)
- <span dir="ltr">[Share snapshots](https://learn.microsoft.com/azure/storage/files/storage-snapshots-files)</span>
- [<bdi dir="ltr">Soft delete</bdi> ל־<bdi dir="ltr">shares</bdi>](https://learn.microsoft.com/azure/storage/files/storage-files-prevent-file-share-deletion)

</div>
