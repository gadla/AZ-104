<div dir="rtl" align="right">

# מודול <bdi dir="ltr">11</bdi> — הדגמות <bdi dir="ltr">Azure Monitor</bdi>

מדריך מלווה נוסף למרצה עבור [המצגת](AZ-104T00A-ENU-PowerPoint_11.pptx); הוא אינו משנה חומרים קיימים. משתמשים ב־<bdi dir="ltr">Storage account</bdi> קטן ובפעולת ניהול בלתי הרסנית במקום למחוק <bdi dir="ltr">VM</bdi> כפי שמודגם בתרשים <bdi dir="ltr">Lab 11.</bdi> ההבדל מצוין במפורש; אין תלות במכונה קיימת או ב־<bdi dir="ltr">agent.</bdi>

## מפת ההדגמות

| הדגמה | שקופיות | זמן משוער | תוצאה |
| ---: | ---: | ---: | ---: |
| <bdi dir="ltr">1. Metrics</bdi> לעומת <bdi dir="ltr">Activity log</bdi> | <span dir="ltr">5–9</span> | <bdi dir="ltr">20</bdi> דקות | נתוני <bdi dir="ltr">resource</bdi> ופעולת <bdi dir="ltr">control plane</bdi> |
| <bdi dir="ltr">2. Activity log alert</bdi> ו־<bdi dir="ltr">Action group</bdi> | <span dir="ltr">12–16, 27–28</span> | <bdi dir="ltr">20</bdi> דקות + <bdi dir="ltr">latency</bdi> | התראה על <bdi dir="ltr">write</bdi> בקבוצת הדמו |
| <span dir="ltr">3. Alert processing rule</span> | <span dir="ltr">15–17, 27–28</span> | <bdi dir="ltr">12</bdi> דקות + <bdi dir="ltr">latency</bdi> | <bdi dir="ltr">suppression</bdi> מוגבל בזמן |
| <bdi dir="ltr">4. Workspace</bdi>, <bdi dir="ltr">diagnostic settings</bdi> ו־<bdi dir="ltr">KQL</bdi> | <span dir="ltr">19–24, 27–28</span> | <bdi dir="ltr">25</bdi> דקות + <bdi dir="ltr">ingestion</bdi> | <bdi dir="ltr">resource logs</bdi> של <bdi dir="ltr">Blob</bdi> |

## הכנה משותפת

1. <bdi dir="ltr">Azure portal > Settings > Directories + subscriptions:</bdi> אמתו <bdi dir="ltr">Tenant</bdi> ו־<bdi dir="ltr">Subscription ID</bdi>, ובחרו אותו מנוי בכל פעולה.
2. צרו <bdi dir="ltr">RG</bdi> חדשה <bdi dir="ltr">`az104-demo11`</bdi> ב־<bdi dir="ltr">West Europe</bdi> עם <bdi dir="ltr">`Purpose=ClassroomDemo`</bdi>. נדרש <bdi dir="ltr">Contributor</bdi> בקבוצה וקריאת <bdi dir="ltr">Activity log</bdi> במנוי; לניהול <bdi dir="ltr">monitoring</bdi> נדרשות פעולות <bdi dir="ltr">Monitoring Contributor</bdi> המתאימות. <bdi dir="ltr">IAM assignments</bdi> דורשים בעל הרשאה בסקופ החשבון בלבד.
3. צרו <bdi dir="ltr">Storage account</bdi> חדש בשם ייחודי <bdi dir="ltr">`az104d11mon261122`</bdi>, <bdi dir="ltr">Standard StorageV2</bdi>, <bdi dir="ltr">LRS</bdi>, <bdi dir="ltr">Hot</bdi>, <bdi dir="ltr">West Europe.</bdi> אם השם תפוס החליפו סיומת. ללא <bdi dir="ltr">HNS</bdi>, <bdi dir="ltr">anonymous access disabled</bdi>, <bdi dir="ltr">TLS 1.2</bdi> ו־<bdi dir="ltr">HTTPS required.</bdi>
4. <bdi dir="ltr">Networking: public access from selected IPs</bdi>, הוסיפו רק <bdi dir="ltr">IP egress</bdi> מאושר של מחשב המרצה. אין צורך ב־<bdi dir="ltr">VNet/VM.</bdi> אם <bdi dir="ltr">Policy</bdi> מחייבת <bdi dir="ltr">Private Link</bdi>, אל תעקפו: אשף/תיעוד בלבד או סביבה פרטית מאושרת מראש.
5. <bdi dir="ltr">IAM:</bdi> הקצו למרצה <bdi dir="ltr">`Storage Blob Data Contributor`</bdi> בסקופ חשבון הדמו, בנוסף להרשאת ניהול. המתינו להפצת <bdi dir="ltr">RBAC.</bdi> ב־<bdi dir="ltr">Storage browser</bdi> בחרו <bdi dir="ltr">Microsoft Entra user account</bdi>; אין <bdi dir="ltr">Access keys</bdi>, <bdi dir="ltr">SAS</bdi> או <bdi dir="ltr">connection strings.</bdi>
6. <bdi dir="ltr">Containers > + Container:</bdi> <bdi dir="ltr">`monitor-demo`</bdi>, <bdi dir="ltr">Private.</bdi> הכינו מקומית ב־<bdi dir="ltr">Notepad</bdi> <bdi dir="ltr">`demo11.txt`</bdi> עם תוכן <bdi dir="ltr">`Monitor sample 1`</bdi>. אין נתונים אישיים.
7. <bdi dir="ltr">Activity log</bdi> מופיע בדרך כלל כ־<bdi dir="ltr">3</bdi>–<bdi dir="ltr">20</bdi> דקות לאחר פעולה; <bdi dir="ltr">resource logs</bdi> ו־<bdi dir="ltr">metrics</bdi> גם מתעכבים. הכינו חלון זמן לפני השיעור; היעדר נתונים אינו תמיד תקלה.

## <bdi dir="ltr">1. Metrics</bdi> לעומת <bdi dir="ltr">Activity log</bdi>

**מטרה:** להבדיל <bdi dir="ltr">management event</bdi> מלוג בקשת נתונים ומ־<bdi dir="ltr">time series numerical metric.</bdi>

**דרישות ומשאבים:** חשבון מההכנה, <bdi dir="ltr">Reader</bdi> לניהול ו־<bdi dir="ltr">Blob data role.</bdi> אין <bdi dir="ltr">workspace</bdi> עדיין ואין <bdi dir="ltr">collection agent.</bdi>

### צעדים

1. <bdi dir="ltr">Resource group</bdi> <bdi dir="ltr">`az104-demo11`</bdi> > <bdi dir="ltr">Tags:</bdi> הוסיפו <bdi dir="ltr">`DemoRound=baseline`</bdi> ושמרו. זו פעולת <bdi dir="ltr">write</bdi> בלתי הרסנית בקבוצת הדמו.
2. <bdi dir="ltr">RG > Activity log: Timespan Last hour</bdi>, <bdi dir="ltr">scope</bdi> לקבוצה; <bdi dir="ltr">Category Administrative</bdi>, <bdi dir="ltr">Status Succeeded.</bdi> רעננו עד שהפעולה מופיעה. פתחו <bdi dir="ltr">details: operation name</bdi>, <bdi dir="ltr">timestamp</bdi> ו־<bdi dir="ltr">correlation ID</bdi>; אל תציגו פרטי זהות מעבר לנדרש.
3. אם אין אירוע עדיין, הסירו מסנן <bdi dir="ltr">Status</bdi> כדי לראות <bdi dir="ltr">Started/Accepted</bdi> ואז המתינו. <bdi dir="ltr">Activity log</bdi> אינו רושם בדרך כלל <bdi dir="ltr">read-only operations.</bdi>
4. <bdi dir="ltr">Storage > Containers ></bdi> <bdi dir="ltr">`monitor-demo`</bdi>: באמצעות <bdi dir="ltr">Entra</bdi> העלו <bdi dir="ltr">`demo11.txt`</bdi>. הורידו אותו כמה פעמים ושנו תוכן ל־<bdi dir="ltr">`Monitor sample 2`</bdi>, העלו עם <bdi dir="ltr">Overwrite.</bdi>
5. <bdi dir="ltr">Storage > Monitoring > Metrics: Scope</bdi> חשבון הדמו; <bdi dir="ltr">Metric namespace</bdi> **<bdi dir="ltr">Blob</bdi>** / <bdi dir="ltr">Blob service</bdi> לפי הממשק. אם נדרש <bdi dir="ltr">scope</bdi> ל־<bdi dir="ltr">Blob service</bdi>, בחרו משאב <bdi dir="ltr">`blobServices/default`</bdi> של חשבון זה.
6. <bdi dir="ltr">Metric</bdi> **<bdi dir="ltr">Transactions</bdi>**, <bdi dir="ltr">Aggregation</bdi> **<bdi dir="ltr">Sum</bdi>**, <bdi dir="ltr">Time range Last hour</bdi>, <bdi dir="ltr">granularity 1 minute/Automatic.</bdi> הוסיפו <bdi dir="ltr">Split by</bdi> **<bdi dir="ltr">API name</bdi>** אם נתמך; הראו <bdi dir="ltr">PutBlob/GetBlob/ListBlobs</bdi> לפי נתוני התרגיל בפועל.
7. הוסיפו <bdi dir="ltr">chart</bdi> של **<bdi dir="ltr">Success E2E Latency</bdi>**, <bdi dir="ltr">aggregation Average</bdi> אם מופיע. אם אין <bdi dir="ltr">sample</bdi>, אל תמציאו מספרים.
8. חזרו ל־<bdi dir="ltr">Activity log.</bdi> בקשת <bdi dir="ltr">GetBlob</bdi> אינה צפויה להופיע שם כ־<bdi dir="ltr">management event. resource logs</bdi> שלה ייאספו רק אחרי <bdi dir="ltr">diagnostic setting</bdi> בהדגמה <bdi dir="ltr">4.</bdi>
9. ניתן להצמיד <bdi dir="ltr">chart</bdi> ללוח מחוונים ייעודי של הדמו בלבד; אין לשנות <bdi dir="ltr">dashboard</bdi> ארגוני.

**תוצאה ואימות:** אירוע <bdi dir="ltr">write</bdi> של <bdi dir="ltr">RG</bdi> ב־<bdi dir="ltr">Activity log</bdi> ו־<bdi dir="ltr">Transactions metric</bdi> אחרי פעילות <bdi dir="ltr">Blob. Metric</bdi> יכול לכלול גם פעולות של <bdi dir="ltr">browser</bdi> ולא רק הקריאה הבודדת שיצרתם.

**תצפית הוראתית:** <bdi dir="ltr">Metrics</bdi> נאספים בשירות בלי <bdi dir="ltr">workspace</bdi>; <bdi dir="ltr">Activity log</bdi> הוא <bdi dir="ltr">control plane</bdi> ונשמר <bdi dir="ltr">90</bdi> ימים כברירת מחדל. <bdi dir="ltr">Resource logs</bdi> הם <bdi dir="ltr">data plane</bdi> ודורשים הגדרת איסוף.

**תקלות:** <bdi dir="ltr">Namespace</bdi> שגוי, <bdi dir="ltr">time range</bdi> צר מדי, <bdi dir="ltr">UTC</bdi> מול זמן מקומי, <bdi dir="ltr">firewall/RBAC</bdi> או <bdi dir="ltr">latency.</bdi> אין להריץ <bdi dir="ltr">loop</bdi> כבד ליצירת עומס; כמה בקשות מספיקות להדגמה.

**ניקוי:** אם נוצר <bdi dir="ltr">dashboard</bdi> חדש, מחקו רק אותו בסוף. השאירו <bdi dir="ltr">RG/Storage</bdi> להמשך; אין למחוק <bdi dir="ltr">logs</bdi> או לנסות להסיר <bdi dir="ltr">Activity log events.</bdi>

## <bdi dir="ltr">2. Activity log alert</bdi> ו־<bdi dir="ltr">Action group</bdi>

**מטרה:** ליצור <bdi dir="ltr">alert</bdi> אמיתי על <bdi dir="ltr">write</bdi> ידוע בלי למחוק <bdi dir="ltr">VM.</bdi> לעומת שקופית <bdi dir="ltr">28</bdi> משתמשים ב־<bdi dir="ltr">`Microsoft.Resources/subscriptions/resourceGroups/write`</bdi>, לא ב־<bdi dir="ltr">VM delete.</bdi>

**דרישות ומשאבים:** <bdi dir="ltr">RG</bdi> מההכנה, <bdi dir="ltr">Contributor/Monitoring Contributor. Alert</bdi> <bdi dir="ltr">`alert-rg-write-demo11`</bdi>, <bdi dir="ltr">Action group</bdi> <bdi dir="ltr">`ag-demo11`</bdi>, <bdi dir="ltr">short name</bdi> <bdi dir="ltr">`az104d11`</bdi>, כתובת דוא״ל של מרצה שהסכים לקבל הודעת דמו. אין <bdi dir="ltr">webhook credentials</bdi>, <bdi dir="ltr">SMS</bdi> או <bdi dir="ltr">automation action.</bdi>

### צעדים

1. <bdi dir="ltr">Monitor > Alerts > Action groups > Create: Subscription</bdi> המאומת, <bdi dir="ltr">RG</bdi> <bdi dir="ltr">`az104-demo11`</bdi>, <bdi dir="ltr">name</bdi> <bdi dir="ltr">`ag-demo11`</bdi>, <bdi dir="ltr">display name</bdi> <bdi dir="ltr">`az104d11`</bdi>, <bdi dir="ltr">region Global</bdi> אם מוצג.
2. <bdi dir="ltr">Notifications > Email/SMS message/Push/Voice > Email</bdi> בלבד: <bdi dir="ltr">name</bdi> <bdi dir="ltr">`InstructorEmail`</bdi>, כתובת מאושרת. בלי לשלוח לתלמידים/רשימת תפוצה. הפעלו <bdi dir="ltr">Common alert schema</bdi> אם מוצג.
3. <bdi dir="ltr">Create. Test action group:</bdi> בחרו <bdi dir="ltr">sample</bdi> מסוג <bdi dir="ltr">Activity log alert</bdi> ושלחו הודעת <bdi dir="ltr">Test</bdi> לכתובת המאושרת. ודאו קבלה; זו **בדיקת <bdi dir="ltr">delivery</bdi>**, לא <bdi dir="ltr">firing</bdi> של <bdi dir="ltr">alert rule.</bdi>
4. <bdi dir="ltr">Monitor > Alerts > Create > Alert rule: Scope</bdi> **<bdi dir="ltr">resource group</bdi> <bdi dir="ltr">`az104-demo11`</bdi> בלבד**. אין <bdi dir="ltr">scope</bdi> לכל המנוי.
5. <bdi dir="ltr">Condition > See all signals > Activity log:</bdi> חפשו **<bdi dir="ltr">Create or Update Resource Group</bdi>**. אמתו <bdi dir="ltr">operation value</bdi> <bdi dir="ltr">`Microsoft.Resources/subscriptions/resourceGroups/write`</bdi> לפי האירוע שיצרתם בהדגמה <bdi dir="ltr">1.</bdi>
6. בחרו <bdi dir="ltr">Category Administrative</bdi>, <bdi dir="ltr">Status</bdi> **<bdi dir="ltr">Succeeded</bdi>**, <bdi dir="ltr">Event level All.</bdi> אם אות זה אינו מוצג בסקופ ה־<bdi dir="ltr">RG</bdi>, פתחו את אירוע <bdi dir="ltr">write</bdi> בהדגמה <bdi dir="ltr">1</bdi> ובחרו **<bdi dir="ltr">Create alert rule</bdi>**, ואז בדקו ש־<bdi dir="ltr">scope/condition</bdi> מוגבלים ל־<bdi dir="ltr">RG</bdi> המדויקת.
7. <bdi dir="ltr">Actions:</bdi> <bdi dir="ltr">`ag-demo11`</bdi>. <bdi dir="ltr">Details: name</bdi> <bdi dir="ltr">`alert-rg-write-demo11`</bdi>, <bdi dir="ltr">RG</bdi> הדמו, <bdi dir="ltr">description</bdi> <bdi dir="ltr">`Demo-only resource group tag write`</bdi>, <bdi dir="ltr">Enable on creation. Create.</bdi>
8. המתינו לסיום יצירה ולכניסת <bdi dir="ltr">rule</bdi> לתוקף. חזרו ל־<bdi dir="ltr">RG > Tags</bdi> ושנו <bdi dir="ltr">`DemoRound=trigger1`</bdi>; <bdi dir="ltr">Save.</bdi>
9. ב־<bdi dir="ltr">Activity log</bdi> ודאו <bdi dir="ltr">Succeeded</bdi> ו־<bdi dir="ltr">operation</bdi> הנכון; אחר כך <bdi dir="ltr">Monitor > Alerts</bdi>, <bdi dir="ltr">scope</bdi> לקבוצת הדמו, <bdi dir="ltr">Last hour.</bdi> המתינו ל־<bdi dir="ltr">firing</bdi> ולדוא״ל.
10. פתחו <bdi dir="ltr">alert:</bdi> בדקו <bdi dir="ltr">rule name</bdi>, <bdi dir="ltr">timestamp</bdi>, <bdi dir="ltr">resource ID</bdi> של <bdi dir="ltr">RG</bdi> הדמו. שנו <bdi dir="ltr">User response</bdi> מ־<bdi dir="ltr">New</bdi> ל־<bdi dir="ltr">Acknowledged</bdi> ואז <bdi dir="ltr">Closed.</bdi> זהו <bdi dir="ltr">workflow</bdi> של אדם, לא שינוי <bdi dir="ltr">condition.</bdi>

**תוצאה ואימות:** <bdi dir="ltr">Test notification</bdi> הגיע וגם **התראת <bdi dir="ltr">rule</bdi> נפרדת** על <bdi dir="ltr">trigger1</bdi> לאחר האירוע. אם רק <bdi dir="ltr">Test</bdi> הגיע, <bdi dir="ltr">rule firing</bdi> עדיין לא הוכח.

**תצפית הוראתית:** <bdi dir="ltr">User response New/Acknowledged/Closed</bdi> שונה מ־<bdi dir="ltr">monitor condition Fired/Resolved. Activity log alerts</bdi> הן אירועיות ואינן בהכרח מתנהגות כמו <bdi dir="ltr">stateful metric alerts.</bdi>

**תקלות:** <bdi dir="ltr">action group test</bdi> לא הגיע → כתובת/<bdi dir="ltr">Spam/</bdi>מדיניות <bdi dir="ltr">delivery. Test</bdi> הגיע אך <bdi dir="ltr">rule</bdi> לא <bdi dir="ltr">fired</bdi> → <bdi dir="ltr">operation/status/scope</bdi> לא נכונים, <bdi dir="ltr">rule disabled</bdi> או <bdi dir="ltr">event</bdi> היה לפני יצירתו. יש להמתין ל־<bdi dir="ltr">latency</bdi>; לא לבצע <bdi dir="ltr">VM delete</bdi> כדי “לכפות” <bdi dir="ltr">alert.</bdi>

**ניקוי:** השאירו <bdi dir="ltr">rule/action group</bdi> להדגמה <bdi dir="ltr">3.</bdi> בסוף <bdi dir="ltr">Disable rule</bdi> ואז מחקו רק <bdi dir="ltr">`alert-rg-write-demo11`</bdi> ו־<bdi dir="ltr">`ag-demo11`</bdi>. אין לשלוח הודעות <bdi dir="ltr">cleanup</bdi> לרשימות אחרות.

## <bdi dir="ltr">3. Alert processing rule</bdi> — <bdi dir="ltr">suppression</bdi> מוגבל

**מטרה:** להראות ש־<bdi dir="ltr">processing rule</bdi> מסיר <bdi dir="ltr">notifications</bdi> מ־<bdi dir="ltr">alerts</bdi> שכבר נוצרו, ולא מונע איסוף אירועים.

**דרישות ומשאבים:** הצלחת הדגמה <bdi dir="ltr">2</bdi>; <bdi dir="ltr">rule</bdi> חדש <bdi dir="ltr">`apr-demo11-maintenance`</bdi> בסקופ <bdi dir="ltr">RG</bdi> הדמו בלבד. לא מיישמים <bdi dir="ltr">suppression</bdi> למנוי.

### צעדים

1. <span dir="ltr">Monitor > Alerts > Alert processing rules > Create: Scope `az104-demo11`.</span>
2. <bdi dir="ltr">Filter: Alert rule name</bdi> <bdi dir="ltr">`alert-rg-write-demo11`</bdi> אם מוצג; אחרת <bdi dir="ltr">rule ID</bdi> המדויק. <bdi dir="ltr">Action</bdi> **<bdi dir="ltr">Suppress notifications / Remove all action groups</bdi>**.
3. <bdi dir="ltr">Schedule:</bdi> חלון <bdi dir="ltr">one-time</bdi> של כ־<bdi dir="ltr">15</bdi> דקות שמתחיל בזמן הנוכחי ומסתיים בשעה מפורשת. בדקו <bdi dir="ltr">time zone</bdi> ו־<bdi dir="ltr">UTC. Name</bdi> <bdi dir="ltr">`apr-demo11-maintenance`</bdi>, <bdi dir="ltr">RG</bdi> הדמו; <bdi dir="ltr">Create.</bdi>
4. אחרי <bdi dir="ltr">activation</bdi> שנו <bdi dir="ltr">tag</bdi> ל־<bdi dir="ltr">`DemoRound=maintenance1`</bdi>. בדקו את האירוע ב־<bdi dir="ltr">Activity log</bdi> ואת <bdi dir="ltr">alert</bdi> ב־<bdi dir="ltr">Alerts.</bdi>
5. הצפי: <bdi dir="ltr">alert</bdi> נוצר, אבל <bdi dir="ltr">action group notification</bdi> מסוננת. בדקו היסטוריית <bdi dir="ltr">alert/actions</bdi> ו־<bdi dir="ltr">processing rule</bdi> אם זמינים; היעדר דוא״ל לבדו אינו הוכחה ל־<bdi dir="ltr">suppression.</bdi>
6. <bdi dir="ltr">Disable processing rule</bdi> מיד אחרי האימות, בלי להמתין לסוף החלון.
7. שנו <bdi dir="ltr">tag</bdi> ל־<bdi dir="ltr">`DemoRound=aftermaintenance1`</bdi>. אחרי <bdi dir="ltr">latency</bdi> ודאו <bdi dir="ltr">alert</bdi> חדש ודוא״ל חדש. אין להסתמך על הודעה ישנה/ב־<bdi dir="ltr">Spam</bdi> כתוצאה מהפעולה החדשה.
8. ציינו שהדגמה יכולה להתארך בגלל <bdi dir="ltr">latency.</bdi> אם אין די זמן, הסתפקו ב־<bdi dir="ltr">rule configuration</bdi> והסבירו שלא אומת <bdi dir="ltr">end-to-end suppression.</bdi>

**תוצאה ואימות:** שני אירועים נפרדים, <bdi dir="ltr">alert</bdi> בזמן <bdi dir="ltr">suppression</bdi> ללא <bdi dir="ltr">action</bdi>, ואחריו <bdi dir="ltr">alert</bdi> עם <bdi dir="ltr">action.</bdi> אם לא התקבלו מספיק נתונים, מסמנים “הוגדר, לא אומת בזמן השיעור”.

**תצפית הוראתית:** <bdi dir="ltr">Disable alert rule</bdi> מונע יצירת <bdi dir="ltr">alert</bdi>; <bdi dir="ltr">processing rule</bdi> משאיר את ה־<bdi dir="ltr">alert</bdi> אבל משנה את הפעלת <bdi dir="ltr">notifications.</bdi>

**תקלות:** <bdi dir="ltr">rule scope</bdi> רחב/צר מדי, <bdi dir="ltr">filter name</bdi> שגוי, <bdi dir="ltr">timezone</bdi>, <bdi dir="ltr">activation delay.</bdi> דוא״ל שכבר נשלח לפני <bdi dir="ltr">suppression</bdi> לא ניתן להחזיר. אל תפעילו <bdi dir="ltr">suppression</bdi> למנוי כדי לבדוק.

**ניקוי:** <bdi dir="ltr">Disable</bdi> ואז <bdi dir="ltr">Delete</bdi> רק <bdi dir="ltr">`apr-demo11-maintenance`</bdi>; בדקו שלא נותר <bdi dir="ltr">suppression</bdi> פעיל. השאירו את <bdi dir="ltr">alert rule</bdi> ללא <bdi dir="ltr">suppression</bdi> עד סוף ההדגמות או כבו אותו אם אין צורך.

## <bdi dir="ltr">4. Log Analytics</bdi>, <bdi dir="ltr">diagnostic settings</bdi> ו־<bdi dir="ltr">KQL</bdi>

**מטרה:** לבצע <bdi dir="ltr">demo</bdi> שקופית <bdi dir="ltr">24</bdi> על נתונים שאספנו בפועל. אין <bdi dir="ltr">VM agent</bdi> ואין <bdi dir="ltr">Event/Heartbeat table</bdi> אוטומטית.

**דרישות ומשאבים:** <bdi dir="ltr">Storage</bdi> מההכנה, <bdi dir="ltr">Contributor</bdi> להגדרת <bdi dir="ltr">diagnostic setting</bdi>, <bdi dir="ltr">Log Analytics Reader/Contributor</bdi> לפי הפעולות. <bdi dir="ltr">Workspace</bdi> חדש <bdi dir="ltr">`law-demo11`</bdi> בקבוצת הדמו, <bdi dir="ltr">West Europe</bdi>, <bdi dir="ltr">pay-as-you-go.</bdi> היקף <bdi dir="ltr">collection</bdi> מוגבל ל־<bdi dir="ltr">Blob</bdi> של חשבון הדמו, לא <bdi dir="ltr">Activity log subscription-wide.</bdi>

### הקמה ואיסוף

1. <bdi dir="ltr">Log Analytics workspaces > Create:</bdi> המנוי המאומת, <bdi dir="ltr">`az104-demo11`</bdi>, <bdi dir="ltr">`law-demo11`</bdi>, <bdi dir="ltr">West Europe. Create.</bdi>
2. <bdi dir="ltr">Usage and estimated costs / Data retention:</bdi> בדקו <bdi dir="ltr">pay-as-you-go</bdi>, <bdi dir="ltr">retention</bdi> בסיסי שמוצג והעלות להארכה. אל תגדילו <bdi dir="ltr">retention. Daily cap</bdi> אופציונלי: בחרו ערך קטן מותר, כגון <bdi dir="ltr">`0.1 GiB`</bdi>, אם נתמך. <bdi dir="ltr">Cap</bdi> אינו הגבלת עלות קשיחה וכללי <bdi dir="ltr">minimum</bdi> משתנים.
3. <bdi dir="ltr">Storage account > Monitoring > Diagnostic settings:</bdi> בחרו **<bdi dir="ltr">Blob</bdi>** <bdi dir="ltr">service.</bdi> אם רשימה מראה <bdi dir="ltr">service resources</bdi>, בחרו <bdi dir="ltr">`blobServices/default`</bdi> של חשבון הדמו.
4. <bdi dir="ltr">Add diagnostic setting:</bdi> <bdi dir="ltr">`diag-blob-demo11`</bdi>; <bdi dir="ltr">Logs</bdi> **<bdi dir="ltr">StorageWrite</bdi>** בלבד לצמצום <bdi dir="ltr">volume. Send to Log Analytics workspace</bdi> <bdi dir="ltr">`law-demo11`</bdi>, <bdi dir="ltr">destination tables</bdi> **<bdi dir="ltr">Resource specific</bdi>**. אין לשלוח ל־<bdi dir="ltr">Event Hub/Storage</bdi> נוסף.
5. <bdi dir="ltr">Save.</bdi> רק בקשות **אחרי** <bdi dir="ltr">Save</bdi> נכללות; אין <bdi dir="ltr">backfill</bdi> של ההעלאות הקודמות.
6. <bdi dir="ltr">Containers ></bdi> <bdi dir="ltr">`monitor-demo`</bdi>, <bdi dir="ltr">authentication Entra:</bdi> שנו תוכן ל־<bdi dir="ltr">`Monitor sample collected 3`</bdi>, <bdi dir="ltr">Upload/Overwrite</bdi> <bdi dir="ltr">`demo11.txt`</bdi>. עשו עוד <bdi dir="ltr">overwrite</bdi> קטן אם נדרש; אין <bdi dir="ltr">loop</bdi> עומס.
7. <bdi dir="ltr">workspace > Logs:</bdi> בחרו <bdi dir="ltr">scope workspace</bdi> ומצב <bdi dir="ltr">KQL. Time range Last hour.</bdi> המתינו ל־<bdi dir="ltr">ingestion</bdi>; תחילת <bdi dir="ltr">collection/table</bdi> יכולה לקחת עשרות דקות.

### שאילתות

החליפו בשם החשבון בפועל אם שונה. מבצעים שאילתות רק על חשבון הדמו, ומקרינים עמודות נבחרות — אין <bdi dir="ltr">URI</bdi> עם <bdi dir="ltr">token</bdi>, <bdi dir="ltr">payload</bdi> או פרטי <bdi dir="ltr">credential.</bdi>

<div dir="ltr" align="right">

```kusto
StorageBlobLogs
| where TimeGenerated > ago(1h)
| where AccountName == "az104d11mon261122"
| project TimeGenerated, OperationName, StatusCode, DurationMs
| order by TimeGenerated desc
| take 20
```

</div>


<div dir="ltr" align="right">

```kusto
StorageBlobLogs
| where TimeGenerated > ago(1h)
| where AccountName == "az104d11mon261122"
| summarize Requests=count(), AverageDurationMs=avg(DurationMs)
    by OperationName, bin(TimeGenerated, 5m)
| order by TimeGenerated desc
```

</div>


<div dir="ltr" align="right">

```kusto
StorageBlobLogs
| where TimeGenerated > ago(1h)
| where AccountName == "az104d11mon261122"
| extend Code=toint(StatusCode)
| where Code >= 400
| summarize Failures=count() by OperationName, Code
```

</div>


1. הריצו את השאילתה הראשונה ואמתו <bdi dir="ltr">OperationName</bdi> של <bdi dir="ltr">write</bdi> וזמן מתאים להעלאה שאחרי <bdi dir="ltr">diagnostic setting.</bdi>
2. בשנייה הראו <bdi dir="ltr">`where`</bdi>, <bdi dir="ltr">`project`</bdi>, <bdi dir="ltr">`summarize`</bdi> ו־<bdi dir="ltr">`bin`</bdi>. תוצאות מסוכמות אינן <bdi dir="ltr">raw events.</bdi>
3. השלישית יכולה להחזיר אפס שורות — זו תוצאה תקינה בלי שגיאות, ולא סיבה לייצר תקלה במערכת.
4. <bdi dir="ltr">Queries hub / built-in queries:</bdi> הציגו <bdi dir="ltr">query template</bdi> של <bdi dir="ltr">Storage</bdi> אם קיים. דוגמאות <bdi dir="ltr">Windows Event</bdi> בשקופית <bdi dir="ltr">23</bdi> דורשות <bdi dir="ltr">Windows VM</bdi>, <bdi dir="ltr">Azure Monitor Agent</bdi> ו־<bdi dir="ltr">Data Collection Rule</bdi> שאוסף <bdi dir="ltr">event logs</bdi>; אלה **לא נוצרו כאן**.
5. אם הטבלה עדיין לא קיימת, אל תציגו שגיאת <bdi dir="ltr">table missing</bdi> כהוכחת כשל. בדקו <bdi dir="ltr">setting/destination/</bdi>פעולות חדשות והמתינו. כדי ללמד <bdi dir="ltr">KQL</bdi> בזמן ההמתנה אפשר להריץ את הדוגמה הסינתטית הבאה, עם סימון ברור “נתוני תרגול, לא <bdi dir="ltr">Azure logs</bdi>”:

    <div dir="ltr" align="right">

    ```kusto
    datatable(Computer:string, EventLevelName:string)
    [
      "demo-vm-a", "Error",
      "demo-vm-a", "Information",
      "demo-vm-b", "Error"
    ]
    | where EventLevelName == "Error"
    | summarize ErrorCount=count() by Computer
    | top 10 by ErrorCount desc
    ```

    </div>


6. התוצאה הסינתטית היא שורה לכל מחשב עם <bdi dir="ltr">ErrorCount</bdi>=<bdi dir="ltr">1</bdi>; אין <bdi dir="ltr">claim</bdi> של <bdi dir="ltr">guest collection.</bdi>

**תוצאה ואימות:** <bdi dir="ltr">`StorageBlobLogs`</bdi> מציגה כתיבות שאחרי <bdi dir="ltr">Save</bdi>, והשאילתות מחזירות/מסכמות את חשבון הדמו. אם נתונים לא הגיעו בזמן, אימות <bdi dir="ltr">KQL</bdi> סינתטי אינו מחליף אימות <bdi dir="ltr">ingestion.</bdi>

**תצפית הוראתית:** <bdi dir="ltr">workspace</bdi> ריק אינו מתמלא מעצמו. <bdi dir="ltr">Resource-specific tables</bdi> נבדלות מ־<bdi dir="ltr">AzureDiagnostics. AzureActivity</bdi> דורשת <bdi dir="ltr">subscription diagnostic setting</bdi> נפרד; הוא לא נוצר כאן כדי להימנע מאיסוף נתונים מכל המנוי.

**תקלות:** <bdi dir="ltr">Resource-specific</bdi> לא נבחר → הנתונים עלולים להיות ב־<bdi dir="ltr">AzureDiagnostics</bdi>; אל תשנו <bdi dir="ltr">query</bdi> לטבלה אחרת בלי לבדוק <bdi dir="ltr">setting. logs</bdi> אינם מתמלאים מקריאה כשבחרנו <bdi dir="ltr">StorageWrite</bdi> בלבד. <bdi dir="ltr">account name/scope/time range</bdi> שגויים; <bdi dir="ltr">RBAC/firewall</bdi>; <bdi dir="ltr">Daily cap</bdi> חוסם <bdi dir="ltr">ingestion.</bdi> לא מתקינים <bdi dir="ltr">Log Analytics agent</bdi> ישן.

**ניקוי סופי:**

1. השביתו/מחקו את <bdi dir="ltr">`diag-blob-demo11`</bdi> קודם כדי להפסיק <bdi dir="ltr">ingestion.</bdi> מחקו <bdi dir="ltr">processing rule</bdi> ו־<bdi dir="ltr">alert rule</bdi> לפני מחיקת קבוצת המקור.
2. מחקו <bdi dir="ltr">action group</bdi> ודוא״ל הדמו, <bdi dir="ltr">blobs</bdi> ו־<bdi dir="ltr">container</bdi>, ואז <bdi dir="ltr">Storage</bdi> של הדמו.
3. מחקו <bdi dir="ltr">workspace</bdi> ייעודי <bdi dir="ltr">`law-demo11`</bdi> ואת קבוצת <bdi dir="ltr">`az104-demo11`</bdi> אחרי סקירת <bdi dir="ltr">ownership. Workspace deletion</bdi> עשויה להשתמש ב־<bdi dir="ltr">soft-delete retention</bdi>; אין לבצע <bdi dir="ltr">purge.</bdi>
4. <bdi dir="ltr">Activity log entries</bdi> ו־<bdi dir="ltr">alert history</bdi> יכולים להישאר בהתאם ל־<bdi dir="ltr">retention</bdi> גם אחרי מחיקת משאבים. אין דרך לנקותם כאילו לא בוצעה פעולה, ואין למחוק <bdi dir="ltr">monitoring/diagnostic settings</bdi> של אחרים.

## מקורות <bdi dir="ltr">Microsoft</bdi>

- <span dir="ltr">[Azure Monitor](https://learn.microsoft.com/azure/azure-monitor/overview)</span>
- [<bdi dir="ltr">Activity log</bdi> ו־<bdi dir="ltr">latency</bdi>](https://learn.microsoft.com/azure/azure-monitor/fundamentals/activity-log)
- <span dir="ltr">[Storage Blob monitoring](https://learn.microsoft.com/azure/storage/blobs/monitor-blob-storage)</span>
- <span dir="ltr">[Activity log alert rules](https://learn.microsoft.com/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule)</span>
- <span dir="ltr">[Action groups](https://learn.microsoft.com/azure/azure-monitor/alerts/action-groups)</span>
- <span dir="ltr">[Alert processing rules](https://learn.microsoft.com/azure/azure-monitor/alerts/alerts-processing-rules)</span>
- <span dir="ltr">[Diagnostic settings](https://learn.microsoft.com/azure/azure-monitor/data-collection/diagnostic-settings)</span>
- <span dir="ltr">[StorageBlobLogs schema](https://learn.microsoft.com/azure/azure-monitor/reference/tables/storagebloblogs)</span>
- <span dir="ltr">[Log Analytics queries](https://learn.microsoft.com/azure/azure-monitor/logs/get-started-queries)</span>

</div>
