<div dir="rtl" align="right">

# מודול <bdi dir="ltr">10</bdi> — מדריך מלווה להדגמות <bdi dir="ltr">Data Protection</bdi>

מדריך נוסף עבור [המצגת](AZ-104T00A-ENU-PowerPoint_10.pptx). הוא **אינו מחליף או משנה** את [<bdi dir="ltr">M10BackupEnvironment.bicep</bdi>](M10BackupEnvironment.bicep) ואת [<bdi dir="ltr">M10BackupResources.bicep</bdi>](M10BackupResources.bicep). הקבצים נקראו לצורך תכנון ההדגמות; אין להריץ אותם כחלק מבדיקת המדריך.

## מפת ההדגמות

| הדגמה | שקופיות | זמן משוער | מגבלה |
| ---: | ---: | ---: | ---: |
| <bdi dir="ltr">1. Vaults</bdi>, <bdi dir="ltr">policies</bdi> ומרכז הניהול | <span dir="ltr">6–9</span> | <bdi dir="ltr">15</bdi> דקות | <bdi dir="ltr">vaults</bdi> ריקים, ללא <bdi dir="ltr">enrollment</bdi> |
| <bdi dir="ltr">2.</bdi> גיבוי ושחזור <bdi dir="ltr">Azure Files</bdi> | <span dir="ltr">10</span> | <bdi dir="ltr">25</bdi> דקות + הכנה מראש | <bdi dir="ltr">backup job/retention</bdi> בתשלום |
| <bdi dir="ltr">3. VM backup</bdi> וסקירת <bdi dir="ltr">restore</bdi> | <span dir="ltr">14–19, 24–25</span> | <bdi dir="ltr">20</bdi> דקות + הכנה מראש | <bdi dir="ltr">VM</bdi> ו־<bdi dir="ltr">backup</bdi> בתשלום |
| <bdi dir="ltr">4. Soft delete</bdi> וסקירת <bdi dir="ltr">Site Recovery</bdi> | <span dir="ltr">20–21, 24–25</span> | <bdi dir="ltr">15</bdi> דקות | סקירה; מחיקה מבוקרת אופציונלית |

## הכנה משותפת

1. <bdi dir="ltr">Azure portal > Settings > Directories + subscriptions:</bdi> אמתו <bdi dir="ltr">Tenant</bdi> ו־<bdi dir="ltr">Subscription ID</bdi>; בחרו אותו מנוי בכל אשף. אין להריץ <bdi dir="ltr">deployment</bdi> על <bdi dir="ltr">context</bdi> שלא אומת.
2. נדרש <bdi dir="ltr">Contributor</bdi> בקבוצת הדמו ליצירת משאבים ו־<bdi dir="ltr">Backup Contributor</bdi> לניהול <bdi dir="ltr">backup</bdi> לפי הרשאות הסביבה; גישה לנתוני <bdi dir="ltr">Files</bdi> דורשת תפקיד <bdi dir="ltr">data</bdi> נפרד. להקצאת <bdi dir="ltr">IAM</bdi> נדרש <bdi dir="ltr">Owner/Role Based Access Control Administrator</bdi> בסקופ החשבון בלבד. <bdi dir="ltr">MUA/Resource Guard</bdi> עשוי לדרוש מאשר נוסף — לא עוקפים אותו.
3. צרו קבוצה חדשה <bdi dir="ltr">`az104-demo10`</bdi> ב־<bdi dir="ltr">West Europe</bdi>, תג <bdi dir="ltr">`Purpose=ClassroomDemo`</bdi>. שמות המסלול הפשוט: <bdi dir="ltr">`rsv-demo10`</bdi>, <bdi dir="ltr">`bv-demo10`</bdi>, חשבון ייחודי <bdi dir="ltr">`az104d10files261122`</bdi>, <bdi dir="ltr">shares</bdi> <bdi dir="ltr">`demo-source`</bdi> ו־<bdi dir="ltr">`demo-restore`</bdi>.
4. גיבוי ראשון יכול לקחת הרבה יותר מזמן השיעור. הכינו מראש <bdi dir="ltr">sample data</bdi> ו־<bdi dir="ltr">Completed job.</bdi> בזמן השיעור הפרידו **הגנה מוגדרת**, **<bdi dir="ltr">snapshot</bdi> זמין** ו־**עותק <bdi dir="ltr">vault</bdi> זמין**. אין להבטיח <bdi dir="ltr">restore point</bdi> מיד לאחר <bdi dir="ltr">Enable backup.</bdi>
5. <bdi dir="ltr">soft delete</bdi> ו־<bdi dir="ltr">retention</bdi> יכולים להשאיר משאבים/נתונים אחרי השיעור. אין להפעיל <bdi dir="ltr">Locked immutability</bdi> לצורך דמו; אין להשבית <bdi dir="ltr">soft delete</bdi>, לבטל <bdi dir="ltr">MUA</bdi> או לבצע <bdi dir="ltr">purge</bdi> כדי לקצר ניקוי.
6. אין לקבל/להציג <bdi dir="ltr">account keys</bdi>, <bdi dir="ltr">connection strings</bdi>, <bdi dir="ltr">SAS</bdi> או <bdi dir="ltr">VM passwords.</bdi> מידע פיקטיבי בלבד. פורטל נתונים באמצעות <bdi dir="ltr">Entra</bdi>; <bdi dir="ltr">credentials</bdi> של <bdi dir="ltr">VM</bdi> מוקלדים בפרטיות.

### התאמה לתבניות הקיימות — מסלול פרטי אופציונלי בלבד

המסלול הפשוט להלן אינו דורש <bdi dir="ltr">deployment</bdi> של התבניות. אם משתמשים בהן בסביבה שאושרה והוכנה מראש, אלה ההגדרות בפועל:

| פריט | ערך בתבניות |
| ---: | ---: |
| <span dir="ltr">Deployment scope</span> | <bdi dir="ltr">Subscription</bdi>, לא <bdi dir="ltr">Resource group</bdi> |
| <span dir="ltr">Resource group</span> | <bdi dir="ltr">`AZ104-M10-Backup`</bdi> — שם קבוע |
| <span dir="ltr">Region</span> | <bdi dir="ltr">`westeurope`</bdi> בלבד, כולל <bdi dir="ltr">private vault DNS</bdi> אזורי |
| פרמטרים | <bdi dir="ltr">`location`</bdi>, <bdi dir="ltr">`adminUsername`</bdi>, <bdi dir="ltr">`adminPassword`</bdi> (<bdi dir="ltr">secure</bdi>, <bdi dir="ltr">12</bdi>–<bdi dir="ltr">123</bdi> תווים), <bdi dir="ltr">`vmSize`</bdi>, <bdi dir="ltr">`adminSourceAddressPrefix`</bdi>, <bdi dir="ltr">`storageAccountName`</bdi>, <bdi dir="ltr">`tags`</bdi> |
| ברירות מחדל | <bdi dir="ltr">username</bdi> <bdi dir="ltr">`azureadmin`</bdi>, <bdi dir="ltr">size</bdi> <bdi dir="ltr">`Standard_B2s`</bdi>, <bdi dir="ltr">storage</bdi> <bdi dir="ltr">`az104backupgadi`</bdi> — יש לבדוק ייחודיות ולהחליף דרך הפרמטר |
| <span dir="ltr">VM</span> | <span dir="ltr">`VmBackup`, Windows Server 2022 Azure Edition, private IP `10.20.0.10`, OS disk `disk-vmbackup-os`</span> |
| רשת | <span dir="ltr">`M10` = `10.20.0.0/16`; `snet-backup` = `10.20.0.0/24`, default outbound disabled</span> |
| <span dir="ltr">Storage/share</span> | <bdi dir="ltr">Standard LRS</bdi>, <bdi dir="ltr">SMB</bdi>, <bdi dir="ltr">share</bdi> **<bdi dir="ltr">`az104backlup`</bdi>** (זה האיות בקובץ), <bdi dir="ltr">quota 100 GiB</bdi>, <bdi dir="ltr">share soft delete 14</bdi> ימים |
| <span dir="ltr">Vault</span> | <bdi dir="ltr">`rsv-m10-backup`</bdi>, <bdi dir="ltr">LRS</bdi>, <bdi dir="ltr">System-assigned identity</bdi>, <bdi dir="ltr">public access disabled</bdi>, <bdi dir="ltr">soft delete 14</bdi> ימים |
| <span dir="ltr">Private endpoints</span> | <span dir="ltr">`pe-m10-files`, `pe-m10-vault`</span> |

התבנית יוצרת <bdi dir="ltr">private DNS zones</bdi> עבור <bdi dir="ltr">File</bdi>, <bdi dir="ltr">Blob</bdi>, <bdi dir="ltr">Queue</bdi> ו־<bdi dir="ltr">`privatelink.we.backup.windowsazure.com`</bdi> עם <bdi dir="ltr">links</bdi> ל־<bdi dir="ltr">M10.</bdi> היא אינה יוצרת <bdi dir="ltr">public IP</bdi>, <bdi dir="ltr">NAT</bdi>, <bdi dir="ltr">Bastion</bdi>, <bdi dir="ltr">corporate connectivity</bdi>, <bdi dir="ltr">policy</bdi> או <bdi dir="ltr">backup enrollment.</bdi>

לפני בחירה במסלול זה:

1. בדקו שהקבוצה הקבועה אינה סביבת מישהו אחר. בדקו <bdi dir="ltr">Subscription deployment permissions</bdi>, <bdi dir="ltr">policies</bdi>, <bdi dir="ltr">registration</bdi>, <bdi dir="ltr">quota</bdi> וזמינות שם <bdi dir="ltr">Storage.</bdi>
2. <bdi dir="ltr">`adminSourceAddressPrefix`</bdi> חייב להיות <bdi dir="ltr">CIDR</bdi> של **לקוח פרטי מאושר**, לא <bdi dir="ltr">`*`</bdi> ולא <bdi dir="ltr">IP</bdi> ציבורי. <bdi dir="ltr">NSG</bdi> מתיר <bdi dir="ltr">RDP</bdi> רק ממנו וחוסם <bdi dir="ltr">RDP</bdi> אחר.
3. נדרשים חיבור פרטי ארגוני מאושר, <bdi dir="ltr">routes/peering</bdi> לא חופפים ו־<bdi dir="ltr">DNS forwarding.</bdi> רשת <bdi dir="ltr">`M10`</bdi> חופפת ל־<bdi dir="ltr">`vnet-nm2`</bdi> במודול <bdi dir="ltr">06</bdi>; **אין לבצע <bdi dir="ltr">peering</bdi> ביניהן**.
4. ספקו <bdi dir="ltr">outbound HTTPS</bdi> מאושר ל־<bdi dir="ltr">VM Agent/Backup</bdi> לפי תיעוד השירות. אין <bdi dir="ltr">Run Command</bdi> אמין בלי <bdi dir="ltr">agent connectivity</bdi>, ואין כניסה פרטית מהמחשב רק מפני שנוצר <bdi dir="ltr">private endpoint.</bdi>
5. לפני שימוש ב־<bdi dir="ltr">Files</bdi> ודאו ש־<bdi dir="ltr">hostname</bdi> של חשבון הדמו נפתר ל־<bdi dir="ltr">private IP</bdi> וש־<bdi dir="ltr">TCP 445</bdi> נגיש ללקוח <bdi dir="ltr">SMB</bdi>; לצפייה/העלאה דרך הפורטל נדרש שגם מחשב המרצה יגיע ל־<bdi dir="ltr">File private endpoint</bdi> ו־<bdi dir="ltr">Entra data role. trusted-services exception</bdi> אינה נתיב לקוח.
6. בדקו <bdi dir="ltr">Private endpoint connection status</bdi> = <bdi dir="ltr">Approved.</bdi> עבור <bdi dir="ltr">VM backup</bdi> דרך <bdi dir="ltr">private endpoints</bdi>, בעל הרשאת <bdi dir="ltr">IAM</bdi> צריך להקצות ל־<bdi dir="ltr">System-assigned managed identity</bdi> של <bdi dir="ltr">`rsv-m10-backup`</bdi> את הרשאות יצירת <bdi dir="ltr">endpoints/DNS</bdi> לפי התיעוד. בסביבה זו <bdi dir="ltr">VNet</bdi>, <bdi dir="ltr">endpoints</bdi> ו־<bdi dir="ltr">DNS</bdi> באותה קבוצה: <bdi dir="ltr">`AZ104-M10-Backup`</bdi> > <bdi dir="ltr">IAM > Add role assignment > Contributor > Managed identity > Recovery Services vault ></bdi> <bdi dir="ltr">`rsv-m10-backup`</bdi>. התבנית יוצרת <bdi dir="ltr">identity</bdi> אך **אינה מקצה <bdi dir="ltr">role</bdi> זה**; אל תרחיבו את ההרשאה למנוי. <bdi dir="ltr">Vault private endpoint</bdi> אינו חל על <bdi dir="ltr">Azure Files backup.</bdi> במסלול התבנית בחרו **<bdi dir="ltr">Vault-Standard</bdi>** בהתאם להכנת הסביבה וה־<bdi dir="ltr">support matrix.</bdi>
7. <bdi dir="ltr">Shared key access</bdi> מופעל בתבנית לשילוב <bdi dir="ltr">Azure Files backup</bdi>, אך **אין לקבל את <bdi dir="ltr">keys</bdi>**. אל תבטלו אותו ללא בדיקת תאימות ו־<bdi dir="ltr">Policy</bdi>; לא משנים תבנית כדי לעקוף מדיניות.
8. בדקו תחילה <bdi dir="ltr">validation/what-if</bdi> בתהליך ההקמה המאושר. הסקריפט שבכותרת התבנית הוא דוגמת <bdi dir="ltr">subscription deployment</bdi>, לא פקודת <bdi dir="ltr">ResourceGroup deployment</bdi>; אין מתגים מומצאים כגון <bdi dir="ltr">`-EnableBackup`</bdi>.

בלי התלויות הפרטיות הללו, השתמשו במסלול הפורטל הפשוט או בסקירת אשפים בלבד. אין להבטיח ש־<bdi dir="ltr">VmBackup</bdi> נגיש אחרי <bdi dir="ltr">template deployment.</bdi>

## <bdi dir="ltr">1. Recovery Services vault</bdi> לעומת <bdi dir="ltr">Backup vault</bdi>

**מטרה:** להתאים <bdi dir="ltr">workload</bdi> לסוג <bdi dir="ltr">vault</bdi> ולזהות <bdi dir="ltr">storage redundancy</bdi> והגנות לפני <bdi dir="ltr">enrollment.</bdi>

**דרישות ומשאבים:** <bdi dir="ltr">`az104-demo10`</bdi>, <bdi dir="ltr">Contributor</bdi>; שני <bdi dir="ltr">vaults</bdi> ריקים: <bdi dir="ltr">`rsv-demo10`</bdi> ו־<bdi dir="ltr">`bv-demo10`</bdi>. אין <bdi dir="ltr">workload</bdi> מוגן עדיין.

### צעדים

1. <bdi dir="ltr">Recovery Services vaults > Create:</bdi> מנוי מאומת, <bdi dir="ltr">`az104-demo10`</bdi>, <bdi dir="ltr">`rsv-demo10`</bdi>, <bdi dir="ltr">West Europe. Review + create</bdi> ואז <bdi dir="ltr">Create.</bdi>
2. <bdi dir="ltr">Vault > Properties > Backup Configuration / Storage replication type:</bdi> בחרו **<bdi dir="ltr">Locally-redundant</bdi>** לפני גיבוי ראשון אם ברירת המחדל אחרת. <bdi dir="ltr">Save.</bdi> שינוי <bdi dir="ltr">replication</bdi> יכול להיחסם אחרי שיש הגנה.
3. <bdi dir="ltr">Properties > Security settings:</bdi> הציגו <bdi dir="ltr">soft delete</bdi>, <bdi dir="ltr">retention</bdi> בפועל, <bdi dir="ltr">immutability</bdi> ו־<bdi dir="ltr">MUA.</bdi> השאירו הגנות קיימות; אל תפעילו <bdi dir="ltr">lock</bdi> בלתי הפיך. במספר סביבות <bdi dir="ltr">secure-by-default</bdi> אינו מאפשר לבטל <bdi dir="ltr">soft delete.</bdi>
4. <bdi dir="ltr">Backup vaults > Create:</bdi> <bdi dir="ltr">`bv-demo10`</bdi>, אותה קבוצה ואזור, <bdi dir="ltr">Storage redundancy LRS</bdi> אם מוצג. אין לבחור <bdi dir="ltr">Azure Site Recovery</bdi> — <bdi dir="ltr">Backup vault</bdi> אינו <bdi dir="ltr">vault</bdi> של <bdi dir="ltr">ASR.</bdi>
5. השוו <bdi dir="ltr">Backup policies/Backup instances</bdi> ב־<bdi dir="ltr">Backup vault</bdi> ל־<bdi dir="ltr">Backup items</bdi> ב־<bdi dir="ltr">Recovery Services vault.</bdi> הראו <bdi dir="ltr">VM/Files</bdi> ב־<bdi dir="ltr">RSV</bdi> לעומת <bdi dir="ltr">Managed Disks/Blobs</bdi> וסוגי <bdi dir="ltr">workload</bdi> מודרניים ב־<bdi dir="ltr">Backup vault</bdi> לפי ה־<bdi dir="ltr">support matrix</bdi> הנוכחי.
6. חפשו **<bdi dir="ltr">Business Continuity Center</bdi>**; בפורטל חדש ייתכן שיופיע **<bdi dir="ltr">Resiliency</bdi>**. בחרו <bdi dir="ltr">scope</bdi> למנוי ולקבוצת הדמו והציגו <bdi dir="ltr">Protected items</bdi>, <bdi dir="ltr">Jobs</bdi> ו־<bdi dir="ltr">Alerts.</bdi> הרשימה הריקה כעת תקינה.
7. הסבירו <bdi dir="ltr">RPO</bdi> כמרווח אובדן אפשרי ו־<bdi dir="ltr">RTO</bdi> כזמן התאוששות בפועל. אין להציג אחוזי הצלחה כלליים מהשקופית כהבטחה לשירות/למנוי.

**תוצאה ואימות:** שני <bdi dir="ltr">vaults</bdi> מסוגים שונים ב־<bdi dir="ltr">West Europe</bdi>, <bdi dir="ltr">RSV LRS</bdi> לפני <bdi dir="ltr">enrollment.</bdi> אין <bdi dir="ltr">restore points</bdi> ואין חיוב <bdi dir="ltr">protected instance</bdi> בשלב זה.

**תצפית הוראתית:** <bdi dir="ltr">vault</bdi> הוא <bdi dir="ltr">container</bdi> ניהולי; <bdi dir="ltr">policy</bdi> ו־<bdi dir="ltr">successful jobs</bdi> הופכים אותו להגנה מעשית. <bdi dir="ltr">Azure SQL Database/App Service</bdi> משתמשים גם במנגנוני <bdi dir="ltr">backup</bdi> ייעודיים מחוץ ל־<bdi dir="ltr">Azure Backup.</bdi>

**תקלות:** <bdi dir="ltr">Region mismatch</bdi> בהמשך גורם לכך ש־<bdi dir="ltr">VM/share</bdi> לא מופיעים. <bdi dir="ltr">Scope</bdi> רחב במרכז הניהול מציג פריטים שאינם הדמו — צמצמו <bdi dir="ltr">filters.</bdi> הרשאת <bdi dir="ltr">Contributor</bdi> ל־<bdi dir="ltr">RG</bdi> אינה מספיקה לכל פעולה המוגנת ב־<bdi dir="ltr">MUA.</bdi>

**ניקוי:** <bdi dir="ltr">`bv-demo10`</bdi> נשאר ריק וניתן לבקש מחיקתו אחרי סקירה, בכפוף להגנת <bdi dir="ltr">vault deletion/soft delete.</bdi> <bdi dir="ltr">`rsv-demo10`</bdi> נשאר להמשך; אין למחוק אותו לפני ניקוי <bdi dir="ltr">backup items.</bdi>

## <bdi dir="ltr">2. Azure Files</bdi> — <bdi dir="ltr">backup</bdi> ושחזור בטוח ליעד נפרד

**מטרה:** לממש את <bdi dir="ltr">demo</bdi> שקופית <bdi dir="ltr">10</bdi>, עם הבדל מפורש בין <bdi dir="ltr">Snapshot</bdi> ל־<bdi dir="ltr">Vault-Standard.</bdi>

**דרישות ומשאבים:** <bdi dir="ltr">RSV</bdi> מהדגמה <bdi dir="ltr">1</bdi>; <bdi dir="ltr">Contributor</bdi> לניהול <bdi dir="ltr">Storage/backup</bdi>; <bdi dir="ltr">`Storage File Data Privileged Contributor`</bdi> ו־<bdi dir="ltr">Reader</bdi> לחשבון לנתוני <bdi dir="ltr">Files</bdi> בפורטל. חשבון <bdi dir="ltr">Standard StorageV2 LRS</bdi> ו־שני <bdi dir="ltr">shares SMB</bdi> קטנים. במסלול בסיסי נבחר <bdi dir="ltr">Snapshot tier</bdi> כדי לצמצם עלות/זמן; בתבנית הפרטית ובמסלול <bdi dir="ltr">vaulted</bdi> בחרו <bdi dir="ltr">Vault-Standard.</bdi>

### הקמת תלויות

1. <bdi dir="ltr">Storage accounts > Create:</bdi> <bdi dir="ltr">`az104d10files261122`</bdi> או שם ייחודי אחר, <bdi dir="ltr">`az104-demo10`</bdi>, <bdi dir="ltr">West Europe</bdi>, <bdi dir="ltr">Standard</bdi>, <bdi dir="ltr">LRS</bdi>, <bdi dir="ltr">Hot</bdi>, <bdi dir="ltr">TLS 1.2</bdi>, <bdi dir="ltr">HTTPS required</bdi>, <bdi dir="ltr">anonymous Blob access disabled</bdi>, ללא <bdi dir="ltr">HNS.</bdi>
2. לפי ה־<bdi dir="ltr">support matrix</bdi>, ודאו **<bdi dir="ltr">Allow storage account key access</bdi> = <bdi dir="ltr">Enabled</bdi>** לשילוב <bdi dir="ltr">Azure Files backup/restore</bdi>, אם <bdi dir="ltr">Policy</bdi> מאפשרת. אין לפתוח <bdi dir="ltr">Access keys</bdi> או לקבל אותם. אם <bdi dir="ltr">Policy</bdi> אוסרת, הדגימו את האשף בלבד עד לפתרון מאושר; אין לעקוף את המדיניות. <bdi dir="ltr">Networking: selected public IP</bdi> של מחשב המרצה והפעלת **<bdi dir="ltr">Allow Azure services on the trusted services list</bdi>** לשילוב <bdi dir="ltr">backup.</bdi> אם <bdi dir="ltr">Policy</bdi> דורשת <bdi dir="ltr">private networking</bdi>, אין להפוך ל־<bdi dir="ltr">All networks</bdi>; השתמשו במסלול התבניות רק עם התלויות שהוכנו.
3. <bdi dir="ltr">File share soft delete Enabled</bdi> ל־<bdi dir="ltr">14</bdi> ימים. <bdi dir="ltr">File shares / Classic file shares > + File share:</bdi> <bdi dir="ltr">`demo-source`</bdi>, <bdi dir="ltr">SMB</bdi>, <bdi dir="ltr">Standard Transaction optimized</bdi>, <bdi dir="ltr">quota</bdi> <bdi dir="ltr">`5 GiB`</bdi> אם המודל מאפשר. צרו גם <bdi dir="ltr">`demo-restore`</bdi> באותו אופן. אם מינימום <bdi dir="ltr">provisioned</bdi> יקר אינו מתאים, סקרו בלי יצירה.
4. <bdi dir="ltr">IAM:</bdi> הקצו למרצה <bdi dir="ltr">Privileged Contributor</bdi> ו־<bdi dir="ltr">Reader</bdi> בסקופ החשבון דרך בעל הרשאה, והמתינו להפצה. <bdi dir="ltr">Browse > Microsoft Entra user account.</bdi>
5. צרו ב־<bdi dir="ltr">Notepad</bdi> קובץ פיקטיבי <bdi dir="ltr">`demo10.txt`</bdi> עם <bdi dir="ltr">`Backup sample version 1`</bdi>; העלו ל־<bdi dir="ltr">`demo-source`</bdi> ואמתו הורדה. <bdi dir="ltr">`demo-restore`</bdi> נשאר ריק.

### גיבוי ושחזור

1. <bdi dir="ltr">`rsv-demo10`</bdi> > <bdi dir="ltr">Backup: Workload Azure > Azure Files</bdi> (<bdi dir="ltr">Azure Storage</bdi>). בחרו את חשבון הדמו. הוא צריך להיות באותו <bdi dir="ltr">region/subscription</bdi> ושלא יהיה רשום ל־<bdi dir="ltr">vault</bdi> אחר.
2. בחרו **רק** <bdi dir="ltr">`demo-source`</bdi>. <bdi dir="ltr">Create new policy:</bdi> <bdi dir="ltr">`policy-files-demo10`</bdi>.
3. במסלול הבסיסי בחרו <bdi dir="ltr">Backup tier</bdi> **<bdi dir="ltr">Snapshot</bdi>**, <bdi dir="ltr">daily</bdi> ב־<bdi dir="ltr">`20:00 UTC`</bdi>, <bdi dir="ltr">retention</bdi> יומי <bdi dir="ltr">`7`</bdi> ימים אם השירות מאפשר. אין <bdi dir="ltr">weekly/monthly/yearly retention</bdi> לצורך דמו.
4. במסלול <bdi dir="ltr">Vault-Standard</bdi> הגדירו <bdi dir="ltr">snapshot retention</bdi> <bdi dir="ltr">`7`</bdi> ימים ו־<bdi dir="ltr">vault daily retention</bdi> <bdi dir="ltr">`7`</bdi> ימים או המינימום שהפורטל מאשר; רשמו את הערך אם גבוה יותר. העברת עותק ה־<bdi dir="ltr">vault</bdi> לפי <bdi dir="ltr">schedule</bdi> אינה זהה לכל <bdi dir="ltr">snapshot</bdi> במשך היום.
5. <bdi dir="ltr">Enable backup. Backup items > Azure Storage</bdi> (<bdi dir="ltr">Azure Files</bdi>) > <bdi dir="ltr">`demo-source`</bdi> > <bdi dir="ltr">Backup now.</bdi> אם נדרש <bdi dir="ltr">Retain till</bdi>, בחרו מועד מותר בהתאם ל־<bdi dir="ltr">policy</bdi>, למשל בעוד <bdi dir="ltr">7</bdi> ימים; אין להניח שניתן למחוק לפניו.
6. <bdi dir="ltr">Backup jobs:</bdi> המתינו ל־<bdi dir="ltr">Completed</bdi> ורשמו <bdi dir="ltr">recovery point timestamp/tier.</bdi> אם אין <bdi dir="ltr">recovery point</bdi>, **אל תשנו את הקובץ לצורך הוכחת <bdi dir="ltr">restore</bdi> עדיין**; עברו לסקירת <bdi dir="ltr">job.</bdi>
7. אחרי נקודת שחזור מאומתת, שנו מקומית ל־<bdi dir="ltr">`Backup sample version 2`</bdi>, העלו ב־<bdi dir="ltr">Overwrite</bdi> למקור בלבד.
8. <bdi dir="ltr">Backup item > Restore share / Recover:</bdi> בחרו את נקודת <bdi dir="ltr">version 1</bdi>, <bdi dir="ltr">Alternate location</bdi>, אותו חשבון, יעד **<bdi dir="ltr">`demo-restore`</bdi>**. <bdi dir="ltr">Choose Skip on conflicts</bdi> אם זמין; היעד ריק ולכן אין <bdi dir="ltr">overwrite</bdi> נתוני משתמש.
9. במסלול <bdi dir="ltr">Snapshot</bdi> ניתן להציג גם <bdi dir="ltr">file-level restore.</bdi> במסלול **<bdi dir="ltr">Vault-Standard restore</bdi> מתוך <bdi dir="ltr">vault</bdi> תומך <bdi dir="ltr">full-share</bdi> בלבד**, לא להבטיח בחירת קובץ בודד. נדרש יעד עם לפחות <bdi dir="ltr">20</bdi>% יותר מקום פנוי מגודל המידע המשוחזר; <bdi dir="ltr">5 GiB</bdi> מספיק לקובץ טקסט קטן, לא לנתוני אמת.
10. הפעילו <bdi dir="ltr">Restore</bdi> רק עם <bdi dir="ltr">point</bdi> זמין ויעד דמו. המתינו ל־<bdi dir="ltr">Completed</bdi>; דרך <bdi dir="ltr">Entra Browse</bdi> הורידו <bdi dir="ltr">`demo-restore/demo10.txt`</bdi> ואמתו <bdi dir="ltr">version 1</bdi>, בעוד המקור נשאר <bdi dir="ltr">version 2.</bdi>

**תוצאה ואימות:** <bdi dir="ltr">Completed backup</bdi>, <bdi dir="ltr">point</bdi> עם <bdi dir="ltr">tier</bdi> ידוע, <bdi dir="ltr">Completed restore</bdi> ותוכן <bdi dir="ltr">version 1</bdi> ביעד נפרד. <bdi dir="ltr">Enable backup/green configuration</bdi> לבדם אינם מבחן שחזור.

**תצפית הוראתית:** <bdi dir="ltr">Snapshot</bdi> נשאר קשור ל־<bdi dir="ltr">Storage</bdi> המקורי; <bdi dir="ltr">vaulted backup</bdi> מוסיף עותק נפרד לטווח ארוך. <bdi dir="ltr">Test restore</bdi> הוא האימות החשוב, לא רק לוח זמנים.

**תקלות:** <bdi dir="ltr">Storage</bdi> לא מופיע → <bdi dir="ltr">region</bdi> שונה, <bdi dir="ltr">registration</bdi> ל־<bdi dir="ltr">vault</bdi> אחר, <bdi dir="ltr">share/type</bdi> לא נתמכים, <bdi dir="ltr">firewall/trusted-services/Policy. Newly created shares</bdi> יכולים להתגלות באיחור. <bdi dir="ltr">Backup now</bdi> אינו מבטיח עותק <bdi dir="ltr">vault</bdi> מיידי. ב־<bdi dir="ltr">REST/</bdi>פורטל <bdi dir="ltr">403</bdi> בדקו <bdi dir="ltr">Entra role</bdi> ורשת; אין לקבל <bdi dir="ltr">key.</bdi>

**ניקוי:** אין למחוק <bdi dir="ltr">account/share</bdi> לפני <bdi dir="ltr">stop protection</bdi> וניקוי <bdi dir="ltr">backup.</bdi> פעלו לפי סעיף הניקוי בסוף המדריך; <bdi dir="ltr">leased backup snapshots/locks</bdi> ו־<bdi dir="ltr">soft delete</bdi> עלולים לחסום מחיקה.

## <bdi dir="ltr">3. VM backup</bdi> וסקירת <bdi dir="ltr">restore</bdi>

**מטרה:** לממש את <bdi dir="ltr">demo</bdi> שקופית <bdi dir="ltr">19</bdi> ולהפריד <bdi dir="ltr">VM snapshot/Instant Restore</bdi> מהעותק ב־<bdi dir="ltr">vault.</bdi>

**דרישות ומשאבים:** <bdi dir="ltr">`rsv-demo10`</bdi> ב־<bdi dir="ltr">West Europe</bdi>; <bdi dir="ltr">VM</bdi> אחת **שנוצרה לדמו שלכם** באותו מנוי ואזור. אם אין <bdi dir="ltr">VM</bdi>, בצעו קודם [מודול <bdi dir="ltr">08</bdi>, הדגמה <bdi dir="ltr">1</bdi>](../Module%2008%20-%20Administer%20Azure%20Virtual%20Machines/Demo-Guide.md): היא יוצרת <bdi dir="ltr">`vm-demo08`</bdi> ב־<bdi dir="ltr">`az104-demo08`</bdi> עם <bdi dir="ltr">network</bdi> וחיבור מוגדרים. אל תבצעו את ניקוי מודול <bdi dir="ltr">08</bdi> לפני סיום <bdi dir="ltr">backup</bdi> כאן. לחלופין <bdi dir="ltr">`VmBackup`</bdi> מתבניות <bdi dir="ltr">M10</bdi> רק עם כל התלויות הפרטיות שהוכנו.

### צעדים

1. <bdi dir="ltr">VM > Overview:</bdi> ודאו <bdi dir="ltr">Region West Europe</bdi>, <bdi dir="ltr">Running</bdi>, <bdi dir="ltr">VM Agent</bdi> תקין ב־<bdi dir="ltr">Properties/Extensions.</bdi> עבור <bdi dir="ltr">`vm-demo08`</bdi> בדקו <bdi dir="ltr">SSH</bdi> מהמקור המוגבל; עבור <bdi dir="ltr">VmBackup</bdi> נדרש מסלול פרטי, אין <bdi dir="ltr">public IP.</bdi>
2. <bdi dir="ltr">RSV > Backup > Azure > Virtual machine > Create new policy:</bdi> <bdi dir="ltr">`policy-vm-demo10`</bdi>, <bdi dir="ltr">Standard policy</bdi> אם נתמך ב־<bdi dir="ltr">VM</bdi> זו, <bdi dir="ltr">Daily</bdi> <bdi dir="ltr">`21:00 UTC`</bdi>, <bdi dir="ltr">daily retention</bdi> <bdi dir="ltr">`7`</bdi> ימים או מינימום השירות. <bdi dir="ltr">Enhanced policy</bdi> מציעה תדירות/<bdi dir="ltr">Instant Restore</bdi> אחרות; סקירה בלבד בדמו זה.
3. <bdi dir="ltr">Instant Restore retention:</bdi> בחרו <bdi dir="ltr">`2`</bdi> ימים אם <bdi dir="ltr">Standard policy</bdi> מאפשרת, ללא <bdi dir="ltr">weekly/monthly/yearly retention.</bdi> בדקו ש־<bdi dir="ltr">policy</bdi> מאפשרת את בחירות ה־<bdi dir="ltr">VM/image/security type.</bdi>
4. <bdi dir="ltr">Add VM:</bdi> בחרו **רק** <bdi dir="ltr">VM</bdi> הדמו (<bdi dir="ltr">`vm-demo08`</bdi> או <bdi dir="ltr">`VmBackup`</bdi>), <bdi dir="ltr">Enable backup.</bdi> אין לבחור את כל <bdi dir="ltr">VMs</bdi> המנוי.
5. <bdi dir="ltr">VM backup item > Backup now</bdi>; <bdi dir="ltr">Retain till</bdi> לפי חלון <bdi dir="ltr">policy</bdi> מותר. <bdi dir="ltr">Jobs:</bdi> בדקו <bdi dir="ltr">Install extension/Snapshot/Transfer data phases.</bdi> גיבוי ראשון יכול לקחת שעות; <bdi dir="ltr">VM Agent</bdi> ונתיב <bdi dir="ltr">HTTPS</bdi> לשירות הם תלויות, לא הבטחה.
6. לאחר <bdi dir="ltr">Completed</bdi>, <bdi dir="ltr">Recovery points:</bdi> הציגו <bdi dir="ltr">timestamp</bdi>, <bdi dir="ltr">consistency type</bdi> ו־<bdi dir="ltr">tier.</bdi> אין להבטיח <bdi dir="ltr">Application-consistent</bdi> לכל <bdi dir="ltr">Linux app</bdi>; בדקו את הערך בפועל.
7. <bdi dir="ltr">Restore VM:</bdi> פתחו אשף ובחרו <bdi dir="ltr">recovery point.</bdi> הציגו <bdi dir="ltr">Create new VM</bdi>, <bdi dir="ltr">Restore disks</bdi> ו־<bdi dir="ltr">Replace existing</bdi> ככל שהם נתמכים. בחרו לצורך סקירה **<bdi dir="ltr">Create new VM</bdi>**, לא <bdi dir="ltr">Replace existing.</bdi>
8. מלאו שם טיוטה <bdi dir="ltr">`vm-restored-demo10`</bdi>, קבוצת דמו, <bdi dir="ltr">VNet/subnet</bdi> של מקור הדמו ו־<bdi dir="ltr">staging storage</bdi> אם האשף דורש. אין <bdi dir="ltr">staging account</bdi> שנוצר אוטומטית במדריך; **<bdi dir="ltr">Cancel</bdi> לפני <bdi dir="ltr">Submit</bdi>**.
9. להוכחת <bdi dir="ltr">restore</bdi> ללא פריסה נוספת השתמשו בשחזור הקובץ שבוצע בהדגמה <bdi dir="ltr">2</bdi>; אל תציגו אותו כ־<bdi dir="ltr">VM restore. VM restore</bdi> חי הוא הרחבה בתשלום שדורשת <bdi dir="ltr">disks</bdi>, <bdi dir="ltr">network</bdi> ו־<bdi dir="ltr">quota</bdi> נוספים ותוכנית בדיקת <bdi dir="ltr">guest.</bdi>

**תוצאה ואימות:** <bdi dir="ltr">VM</bdi> רשומה ל־<bdi dir="ltr">policy</bdi> ו־<bdi dir="ltr">job Completed</bdi> אם הוכן בזמן; <bdi dir="ltr">restore options</bdi> נבדקו בלי ליצור <bdi dir="ltr">VM.</bdi> אם <bdi dir="ltr">backup</bdi> טרם הסתיים, התוצאה היא <bdi dir="ltr">enrollment</bdi> ו־<bdi dir="ltr">job running</bdi> בלבד.

**תצפית הוראתית:** <bdi dir="ltr">Instant Restore</bdi> מקצר חלק מזמן השחזור דרך <bdi dir="ltr">snapshots</bdi>; הוא אינו מייתר העברת <bdi dir="ltr">data</bdi> ל־<bdi dir="ltr">vault</bdi> או בדיקת יישום אחרי <bdi dir="ltr">restore.</bdi>

**תקלות:** <bdi dir="ltr">VM</bdi> אינה מופיעה → <bdi dir="ltr">region/subscription</bdi>, כבר מוגנת ב־<bdi dir="ltr">vault</bdi> אחר, סוג דיסק/<bdi dir="ltr">VM</bdi> לא נתמך. <bdi dir="ltr">extension timeout</bdi> → <bdi dir="ltr">Agent</bdi>, <bdi dir="ltr">egress</bdi>, <bdi dir="ltr">DNS</bdi>, <bdi dir="ltr">service endpoints</bdi> או <bdi dir="ltr">OS health.</bdi> אין להתיר <bdi dir="ltr">inbound Internet</bdi> כדי לתקן <bdi dir="ltr">backup extension.</bdi>

**ניקוי:** פעלו קודם לפי ניקוי <bdi dir="ltr">backup item</bdi> בסוף; רק אחר כך מחקו <bdi dir="ltr">VM/OS disk</bdi> וקבוצת מודול <bdi dir="ltr">08</bdi> ששייכת לכם. <bdi dir="ltr">Stop VM</bdi> בלבד אינו מסיר <bdi dir="ltr">backup costs</bdi> או <bdi dir="ltr">retention.</bdi>

## <bdi dir="ltr">4. Soft delete</bdi> ו־<bdi dir="ltr">Site Recovery</bdi> — הגנות שונות

**מטרה:** להבדיל התאוששות ממחיקת <bdi dir="ltr">backup</bdi> מ־<bdi dir="ltr">disaster recovery</bdi> של <bdi dir="ltr">workload.</bdi>

**דרישות ומשאבים:** <bdi dir="ltr">vault</bdi> ו־<bdi dir="ltr">backup item</bdi> של הדמו; <bdi dir="ltr">Reader/Backup Reader</bdi> לסקירה, <bdi dir="ltr">Backup Contributor</bdi> למחיקה מבוקרת. <bdi dir="ltr">ASR</bdi> נבדק באשף בלבד; אין <bdi dir="ltr">target region resources</bdi> פעילים.

### <bdi dir="ltr">Soft delete</bdi> — מסלול רגיל לקריאה בלבד

1. <bdi dir="ltr">RSV > Properties > Security settings:</bdi> הציגו <bdi dir="ltr">retention</bdi> בפועל. ברירת מחדל נפוצה <bdi dir="ltr">14</bdi> ימים, אפשרויות מורחבות עשויות לעלות כסף; <bdi dir="ltr">secure-by-default</bdi> יכול להפוך את ההגנה לבלתי ניתנת להשבתה.
2. <bdi dir="ltr">Backup items ></bdi> פריט הדמו > <bdi dir="ltr">Stop backup:</bdi> הציגו **<bdi dir="ltr">Retain backup data</bdi>** לעומת **<bdi dir="ltr">Delete backup data</bdi>**, ואז <bdi dir="ltr">Cancel. Retain</bdi> אינו מפנה את ה־<bdi dir="ltr">vault.</bdi>
3. הסבירו <bdi dir="ltr">Undelete:</bdi> מחזיר פריט למצב <bdi dir="ltr">Stop protection with retain data</bdi>; צריך <bdi dir="ltr">Resume backup</bdi> כדי לחדש <bdi dir="ltr">schedule.</bdi> זו אינה פעולת <bdi dir="ltr">restore</bdi> ל־<bdi dir="ltr">VM</bdi> או <bdi dir="ltr">share</bdi> המקור.
4. אופציונלי, רק כאשר ממילא מסיימים את הדמו: <bdi dir="ltr">Stop backup > Delete backup data</bdi> על **פריט דמו אחד בלבד** לאחר אימות שם/<bdi dir="ltr">ownership</bdi> והשלמת מבחן <bdi dir="ltr">restore.</bdi> אם <bdi dir="ltr">MUA/immutability</bdi> חוסמים, עצרו.
5. הציגו <bdi dir="ltr">Soft-deleted items > Undelete</bdi>, ואמתו שהפריט חוזר למצב <bdi dir="ltr">retention.</bdi> אם מפעילים <bdi dir="ltr">Resume</bdi>, בדקו <bdi dir="ltr">policy</bdi> ו־<bdi dir="ltr">schedule</bdi>; אם לא, הוא עדיין דורש ניקוי בהמשך.

### <bdi dir="ltr">Site Recovery</bdi> — אשף ללא <bdi dir="ltr">Enable replication</bdi>

1. <bdi dir="ltr">VM</bdi> הדמו > <bdi dir="ltr">Disaster recovery</bdi>, או <bdi dir="ltr">Recovery Services vault > Site Recovery > Enable replication.</bdi>
2. הציגו <bdi dir="ltr">Source region West Europe</bdi>; <bdi dir="ltr">Target region</bdi> לדוגמה <bdi dir="ltr">North Europe</bdi> **רק אם נתמך**. אל תשמרו.
3. הראו <bdi dir="ltr">target RG/VNet/subnet</bdi>, <bdi dir="ltr">target VM size</bdi>, <bdi dir="ltr">replica disks</bdi>, <bdi dir="ltr">cache storage</bdi>, <bdi dir="ltr">replication policy</bdi> ו־<bdi dir="ltr">vault</bdi> מתאים לאזור היעד. אלה תלויות שלא נוצרו בדמו.
4. הציגו <bdi dir="ltr">replication policy</bdi> ותכנון <bdi dir="ltr">RPO/RTO</bdi>, ואז <bdi dir="ltr">Cancel</bdi> לפני **<bdi dir="ltr">Enable replication</bdi>**. לא צפויה <bdi dir="ltr">replication health</bdi> או <bdi dir="ltr">recovery point</bdi> של <bdi dir="ltr">ASR.</bdi>
5. בתכנון <bdi dir="ltr">test failover</bdi> הסבירו צורך ב־<bdi dir="ltr">VNet</bdi> יעד מבודד שאינו מחובר לייצור, <bdi dir="ltr">quota</bdi> ל־<bdi dir="ltr">test VM</bdi>, בדיקות <bdi dir="ltr">guest</bdi> ו־**<bdi dir="ltr">Cleanup test failover</bdi>**. אין לבצע <bdi dir="ltr">production Failover/Commit</bdi> לצורך שיעור.

**תוצאה ואימות:** אין <bdi dir="ltr">replication resources/jobs</bdi> חדשים; הובהר ש־<bdi dir="ltr">backup points</bdi> אינם <bdi dir="ltr">ASR recovery points.</bdi> אם בוצעה מחיקה אופציונלית, מצב <bdi dir="ltr">soft-deleted/undeleted</bdi> מאומת בפורטל.

**תצפית הוראתית:** <bdi dir="ltr">Backup</bdi> מחזיר <bdi dir="ltr">data</bdi> בנקודת זמן; <bdi dir="ltr">ASR</bdi> מתזמר <bdi dir="ltr">replication/failover. replication</bdi> אינה גיבוי נגד כל מחיקה לוגית או <bdi dir="ltr">ransomware.</bdi>

**תקלות:** <bdi dir="ltr">immutability locked</bdi>, <bdi dir="ltr">MUA</bdi>, <bdi dir="ltr">active jobs</bdi> או <bdi dir="ltr">retention</bdi> מונעים <bdi dir="ltr">delete</bdi>; זו הגנה צפויה. <bdi dir="ltr">ASR target region/size/capacity</bdi> מוגבלים, ו־<bdi dir="ltr">initial replication</bdi> עלולה לקחת שעות וליצור חיובי <bdi dir="ltr">disks/storage</bdi> גם לפני <bdi dir="ltr">failover.</bdi>

**ניקוי:** השליכו <bdi dir="ltr">ASR draft.</bdi> אם הסביבה כבר הפעילה <bdi dir="ltr">ASR</bdi> מחוץ לדמו זה, לא מוחקים <bdi dir="ltr">VM/vault</bdi>; בעל הסביבה יסיים <bdi dir="ltr">test failover</bdi>, יבטל רק <bdi dir="ltr">replication</bdi> של משאבי הדמו וינקה <bdi dir="ltr">target/cache</bdi> בהתאם לתיעוד.

## ניקוי סופי — אין עקיפת הגנות

1. רשמו את כל פריטי <bdi dir="ltr">backup</bdi> ואת קבוצות המקור (<bdi dir="ltr">`az104-demo10`</bdi>, ואולי <bdi dir="ltr">`az104-demo08`</bdi> או <bdi dir="ltr">`AZ104-M10-Backup`</bdi>). ודאו שאין <bdi dir="ltr">workloads</bdi> אחרים ושאין <bdi dir="ltr">jobs</bdi> פעילים.
2. לכל פריט דמו בלבד, <bdi dir="ltr">Stop protection > Delete backup data</bdi> אם ה־<bdi dir="ltr">retention/security</bdi> מאפשרים. אין לבחור <bdi dir="ltr">Delete</bdi> כשנדרש עדיין <bdi dir="ltr">restore.</bdi> אם בוחרים <bdi dir="ltr">Retain</bdi>, עלות ו־<bdi dir="ltr">vault dependency</bdi> יכולים להישאר.
3. בדקו <bdi dir="ltr">Soft-deleted items.</bdi> המתינו ל־<bdi dir="ltr">retention/expiry</bdi> לפי ה־<bdi dir="ltr">vault</bdi>; **אין <bdi dir="ltr">disable soft delete</bdi>, <bdi dir="ltr">purge</bdi> או <bdi dir="ltr">unlock immutability</bdi>**. מחיקת <bdi dir="ltr">vault</bdi> עצמה יכולה להיות מוגנת/<bdi dir="ltr">soft-deleted.</bdi>
4. ב־<bdi dir="ltr">Azure Files</bdi> בדקו <bdi dir="ltr">Backup Infrastructure > Storage accounts / containers: unregister</bdi> **רק חשבון הדמו** כשאין <bdi dir="ltr">items/jobs</bdi> והמערכת מאפשרת. אין למחוק <bdi dir="ltr">leases/locks</bdi> של <bdi dir="ltr">backup</bdi> ידנית. מחיקת <bdi dir="ltr">shares</bdi> עשויה להשאיר <bdi dir="ltr">soft-deleted shares 14</bdi> ימים.
5. לאחר השלמת <bdi dir="ltr">cleanup</bdi> המותר, בקשו מחיקת <bdi dir="ltr">vaults</bdi> ריקים, <bdi dir="ltr">shares/storage</bdi> ו־<bdi dir="ltr">VMs</bdi> של הדמו. במסלול הפרטי השאירו <bdi dir="ltr">private endpoints/DNS/network</bdi> עד שהטיפול ב־<bdi dir="ltr">backup</bdi> הושלם.
6. אם הגנה חוסמת מחיקת <bdi dir="ltr">RG</bdi>, השאירו את המשאבים החסומים עם <bdi dir="ltr">owner/tag</bdi> ורשמו מועד מעקב. <bdi dir="ltr">Deallocate VM</bdi> להפסקת <bdi dir="ltr">compute</bdi> כשלא נדרשת לפעולות, אבל <bdi dir="ltr">disks/backup/Private Link</bdi> ממשיכים לחייב.

## מקורות <bdi dir="ltr">Microsoft</bdi>

- <span dir="ltr">[Azure Backup overview](https://learn.microsoft.com/azure/backup/backup-overview)</span>
- <span dir="ltr">[Business Continuity Center](https://learn.microsoft.com/azure/business-continuity-center/business-continuity-center-overview)</span>
- [גיבוי <bdi dir="ltr">Azure Files</bdi> בפורטל](https://learn.microsoft.com/azure/backup/backup-azure-files)
- <span dir="ltr">[Azure Files support matrix](https://learn.microsoft.com/azure/backup/azure-file-share-support-matrix)</span>
- [שחזור <bdi dir="ltr">Azure Files</bdi> ומגבלות <bdi dir="ltr">vaulted restore</bdi>](https://learn.microsoft.com/azure/backup/restore-afs)
- [<bdi dir="ltr">Azure Files OAuth</bdi> בפורטל](https://learn.microsoft.com/azure/storage/files/authorize-data-operations-portal)
- [<bdi dir="ltr">VM backup</bdi> בפורטל](https://learn.microsoft.com/azure/backup/backup-azure-vms-first-look-arm)
- <span dir="ltr">[Backup Private Endpoints](https://learn.microsoft.com/azure/backup/private-endpoints)</span>
- [<bdi dir="ltr">Secure by default</bdi> ו־<bdi dir="ltr">soft delete</bdi>](https://learn.microsoft.com/azure/backup/secure-by-default)
- <span dir="ltr">[Immutable vault](https://learn.microsoft.com/azure/backup/backup-azure-immutable-vault-concept)</span>
- <span dir="ltr">[ASR Azure-to-Azure](https://learn.microsoft.com/azure/site-recovery/azure-to-azure-tutorial-enable-replication)</span>

</div>
