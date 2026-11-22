<div dir="rtl" align="right">

# <bdi dir="ltr">Module 02</bdi> — מדריך הדגמות: <bdi dir="ltr">Governance and Compliance</bdi>

מצגת: [<bdi dir="ltr">AZ-104T00A-ENU-PowerPoint_02.pptx</bdi>](./AZ-104T00A-ENU-PowerPoint_02.pptx).
הדגמות אלו מחברות את הערות המרצה להדגמות <bdi dir="ltr">Policy</bdi> בשקופית <bdi dir="ltr">20</bdi> ו־<bdi dir="ltr">RBAC</bdi> בשקופית <bdi dir="ltr">28</bdi>, ולתרחישי <bdi dir="ltr">Labs 02a/02b.</bdi> המספור כולל את שקופיות ההרחבה שאחרי הסיום.

## תכנון, הכנות ובטיחות

| הדגמה | שקופיות | זמן | תלויות |
|---:|---:|---:|---:|
| <bdi dir="ltr">1. Resource group</bdi>, <bdi dir="ltr">Tags</bdi> ו־<bdi dir="ltr">Locks</bdi> | <span dir="ltr">10–13, 33–34, 40</span> | <bdi dir="ltr">15</bdi> דקות | <bdi dir="ltr">RG</bdi> ושני <bdi dir="ltr">VNets</bdi> ללא <bdi dir="ltr">VM</bdi> |
| <bdi dir="ltr">2. Reader</bdi> ב־<bdi dir="ltr">Scope</bdi> מוגבל | <span dir="ltr">24–28, 31–32, 36–37</span> | <bdi dir="ltr">15</bdi> דקות | <bdi dir="ltr">RG</bdi> מהדגמה <bdi dir="ltr">1</bdi>; חשבון בדיקה |
| <bdi dir="ltr">3. Deny</bdi> ו־<bdi dir="ltr">Initiative</bdi> | <span dir="ltr">18–20, 33–34</span> | <bdi dir="ltr">20</bdi> דקות | <bdi dir="ltr">RG</bdi> מהדגמה <bdi dir="ltr">1</bdi> |
| <bdi dir="ltr">4. Modify</bdi> ו־<bdi dir="ltr">Remediation</bdi> | <span dir="ltr">18–20, 33–34</span> | <bdi dir="ltr">20</bdi> דקות ועוד זמן הערכה | אופציונלי; הרשאת <bdi dir="ltr">RBAC</bdi> לזהות |
| <bdi dir="ltr">5.</bdi> היררכיה, <bdi dir="ltr">Quotas</bdi> ו־<bdi dir="ltr">Budget</bdi> | <span dir="ltr">6–14, 31</span> | <bdi dir="ltr">15</bdi> דקות | קריאה; <bdi dir="ltr">Budget</bdi> אופציונלי ב־<bdi dir="ltr">RG</bdi> |

- ב־[<bdi dir="ltr">Azure portal</bdi>](https://portal.azure.com) > **<bdi dir="ltr">Settings > Directories + subscriptions</bdi>** אשרו <bdi dir="ltr">Tenant</bdi> ומינוי מעבדה. בכל אשף בדקו <bdi dir="ltr">Subscription</bdi> מחדש. אין להזיז מינוי בין <bdi dir="ltr">Management groups</bdi>, לרכוש מינוי, להגדיל <bdi dir="ltr">Quota</bdi> או לשנות <bdi dir="ltr">Tenant root.</bdi>
- צרו רק <bdi dir="ltr">RG</bdi> חדש בשם <bdi dir="ltr">`rg-az104-m02-demo`</bdi> ב־<bdi dir="ltr">`West Europe`</bdi>, עם <bdi dir="ltr">Tag</bdi> <bdi dir="ltr">`DemoOwner=AZ104-M02`</bdi>. אם קיים, עצרו ובחרו שם חדש לכל ההדגמות. אין להשתמש ב־<bdi dir="ltr">RG</bdi> של מעבדה אחרת.
- מנהל המעבדה יספק מראש <bdi dir="ltr">Contributor</bdi> לניהול המשאבים, <bdi dir="ltr">Resource Policy Contributor</bdi> לניהול <bdi dir="ltr">Policy</bdi>, והרשאת <bdi dir="ltr">`Microsoft.Authorization/roleAssignments/write`</bdi> ב־<bdi dir="ltr">RG</bdi> בלבד עבור הקצאות. יצירת/מחיקת <bdi dir="ltr">Locks</bdi> דורשת <bdi dir="ltr">`Microsoft.Authorization/locks/*`</bdi>, למשל <bdi dir="ltr">Owner</bdi> ב־<bdi dir="ltr">RG. Contributor</bdi> לבדו אינו מספיק לכל הפעולות.
- אין להעניק <bdi dir="ltr">Global Administrator</bdi>, <bdi dir="ltr">Owner</bdi> במינוי או הרשאת <bdi dir="ltr">Root</bdi> למשתתף. <bdi dir="ltr">Definition</bdi> של <bdi dir="ltr">Initiative</bdi> נשמר ברמת מינוי כי אין <bdi dir="ltr">Definition scope</bdi> ברמת <bdi dir="ltr">RG</bdi>, אך ה־<bdi dir="ltr">Assignment</bdi> יהיה **רק** ב־<bdi dir="ltr">RG</bdi> של ההדגמה.
- <bdi dir="ltr">Policy</bdi> ו־<bdi dir="ltr">Cost Management</bdi> הם אסינכרוניים. אין להבטיח <bdi dir="ltr">Compliance</bdi>, <bdi dir="ltr">Remediation</bdi> או הודעת <bdi dir="ltr">Budget</bdi> תוך דקות. אין לפרוס <bdi dir="ltr">VM</bdi> או שירות בתשלום כדי לייצר הוצאות.

## הדגמה <bdi dir="ltr">1</bdi> — ארגון משאבים, <bdi dir="ltr">Tags</bdi> ו־<bdi dir="ltr">CanNotDelete</bdi>

**מטרה:** להמחיש <bdi dir="ltr">Lifecycle</bdi> משותף, אי־ירושה אוטומטית של <bdi dir="ltr">Tags</bdi> וירושת <bdi dir="ltr">Management locks.</bdi>

**דרישות:** הרשאות יצירת <bdi dir="ltr">RG</bdi> ומשאבי <bdi dir="ltr">Network</bdi>; הרשאת <bdi dir="ltr">Locks</bdi> ב־<bdi dir="ltr">RG.</bdi> המשאבים: <bdi dir="ltr">`vnet-m02-existing`</bdi>, <bdi dir="ltr">`vnet-m02-locktest`</bdi>. אין <bdi dir="ltr">Peering</bdi>, <bdi dir="ltr">Public IP</bdi> או <bdi dir="ltr">VM</bdi> ולכן אין חיוב <bdi dir="ltr">Compute.</bdi>

### צעדים

1. **<bdi dir="ltr">Resource groups > Create</bdi>**: המינוי המאושר, <bdi dir="ltr">`rg-az104-m02-demo`</bdi>, <bdi dir="ltr">Region</bdi> **<bdi dir="ltr">West Europe</bdi>**. ב־**<bdi dir="ltr">Tags</bdi>** הוסיפו <bdi dir="ltr">`DemoOwner=AZ104-M02`</bdi> ו־<bdi dir="ltr">`CostCenter=AZ104-Class`</bdi> > **<bdi dir="ltr">Review + create > Create</bdi>**.
2. **<bdi dir="ltr">Virtual networks > Create</bdi>**: אותו <bdi dir="ltr">RG</bdi>, <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`vnet-m02-existing`</bdi>, <bdi dir="ltr">Region</bdi> **<bdi dir="ltr">West Europe</bdi>**. ב־**<bdi dir="ltr">IP addresses</bdi>** הגדירו <bdi dir="ltr">`10.22.0.0/16`</bdi>, <bdi dir="ltr">Subnet</bdi> <bdi dir="ltr">`snet-demo`</bdi> עם <bdi dir="ltr">`10.22.1.0/24`</bdi>; מחקו <bdi dir="ltr">Subnet</bdi> ברירת מחדל אם הוא מתנגש. ב־<bdi dir="ltr">Security</bdi> אל תפעילו <bdi dir="ltr">Bastion</bdi>, <bdi dir="ltr">Firewall</bdi> או <bdi dir="ltr">DDoS paid plan.</bdi> אל תוסיפו <bdi dir="ltr">Tags</bdi> ל־<bdi dir="ltr">VNet.</bdi> צרו.
3. פתחו **<bdi dir="ltr">VNet > Tags</bdi>**: <bdi dir="ltr">Tag</bdi> ה־<bdi dir="ltr">CostCenter</bdi> של ה־<bdi dir="ltr">RG</bdi> אינו מועתק אוטומטית. חזרו ל־<bdi dir="ltr">RG</bdi> ובדקו שה־<bdi dir="ltr">Tag</bdi> שם קיים.
4. צרו <bdi dir="ltr">VNet</bdi> שני <bdi dir="ltr">`vnet-m02-locktest`</bdi> באותו <bdi dir="ltr">RG</bdi> ואזור, <bdi dir="ltr">`10.23.0.0/16`</bdi>, <bdi dir="ltr">Subnet</bdi> <bdi dir="ltr">`snet-demo`</bdi> עם <bdi dir="ltr">`10.23.1.0/24`</bdi>, ללא שירותים נוספים.
5. ב־**<bdi dir="ltr">RG > Locks > Add</bdi>** צרו <bdi dir="ltr">`lock-m02-demo`</bdi>, <bdi dir="ltr">Lock type</bdi> **<bdi dir="ltr">Delete</bdi>**. זהו <bdi dir="ltr">CanNotDelete</bdi>, לא <bdi dir="ltr">ReadOnly.</bdi>
6. ב־<bdi dir="ltr">`vnet-m02-locktest`</bdi> נסו **<bdi dir="ltr">Delete</bdi>** ואשרו רק את שמו. המחיקה אמורה להיכשל בגלל <bdi dir="ltr">Lock.</bdi> זו בדיקת מחיקה של משאב ריק שבבעלות הדמו בלבד.
7. ב־**<bdi dir="ltr">VNet > Tags</bdi>** הוסיפו <bdi dir="ltr">`DemoTest=LockAllowsUpdate`</bdi> ושמרו: <bdi dir="ltr">Lock</bdi> מסוג <bdi dir="ltr">Delete</bdi> אינו מונע עדכון.
8. חזרו ל־**<bdi dir="ltr">RG > Locks</bdi>** והסירו **רק** <bdi dir="ltr">`lock-m02-demo`</bdi>. מחקו כעת את <bdi dir="ltr">`vnet-m02-locktest`</bdi> ובדקו שנעלם מרשימת המשאבים.

**תוצאה ואימות:** <bdi dir="ltr">Tag</bdi> אינו יורש אוטומטית; <bdi dir="ltr">Delete</bdi> נחסם בזמן <bdi dir="ltr">Lock</bdi> ומצליח אחרי הסרתו; כתיבה ל־<bdi dir="ltr">Tag</bdi> אפשרית תחת <bdi dir="ltr">CanNotDelete.</bdi>

**נקודת הוראה:** <bdi dir="ltr">Lock</bdi> פועל על <bdi dir="ltr">Management plane</bdi> ולא מהווה בקרת גישה לנתונים. גם <bdi dir="ltr">Owner</bdi> צריך להסיר <bdi dir="ltr">Lock</bdi> לפני מחיקה. <bdi dir="ltr">Resource group</bdi> אינו ניתן לקינון או לשינוי שם.

**תקלות נפוצות:** מחיקה מצליחה — בדקו <bdi dir="ltr">Scope</bdi> וסוג <bdi dir="ltr">Lock</bdi>; עדכון <bdi dir="ltr">Tag</bdi> נכשל — בדקו <bdi dir="ltr">ReadOnly</bdi> או <bdi dir="ltr">Policy</bdi> שהורש מלמעלה. אין להסיר <bdi dir="ltr">Lock</bdi> או <bdi dir="ltr">Policy</bdi> שלא נוצרו בדמו.

**ניקוי:** <bdi dir="ltr">Lock</bdi> ו־<bdi dir="ltr">VNet</bdi> הבדיקה הוסרו. השאירו <bdi dir="ltr">`vnet-m02-existing`</bdi> ואת <bdi dir="ltr">RG</bdi> להדגמות הבאות; אם עוצרים כאן, מחקו רק <bdi dir="ltr">RG</bdi> זה אחרי בדיקת רשימת משאביו.

## הדגמה <bdi dir="ltr">2</bdi> — <bdi dir="ltr">Role definition</bdi> מול <bdi dir="ltr">Role assignment</bdi>

**מטרה:** ליצור <bdi dir="ltr">Reader</bdi> על <bdi dir="ltr">RG</bdi> אחד ולבדוק שהגישה אינה מאפשרת כתיבה.

**דרישות:** <bdi dir="ltr">Role assignment write/delete</bdi> ב־<bdi dir="ltr">RG</bdi>; חשבון בדיקה <bdi dir="ltr">Cloud-only</bdi> שסופק למעבדה ללא תפקידי <bdi dir="ltr">Azure</bdi> קיימים, למשל המשתמש מה־[מדריך <bdi dir="ltr">Module 01</bdi>](../Module%2001%20-%20Identity/Demo-Guide.md). אין ליצור משתמש חדש באמצעות <bdi dir="ltr">Azure RBAC.</bdi> אם אין חשבון כזה, מסתפקים בבדיקת <bdi dir="ltr">Definition</bdi> ו־<bdi dir="ltr">Check access.</bdi>

### צעדים

1. ב־**<bdi dir="ltr">rg-az104-m02-demo > Access control</bdi> (<bdi dir="ltr">IAM</bdi>) > <bdi dir="ltr">Roles</bdi>**, חפשו **<bdi dir="ltr">Reader</bdi>**, פתחו **<bdi dir="ltr">View > Permissions</bdi>**. הציגו קריאה ב־<bdi dir="ltr">Management plane.</bdi> השוו ל־<bdi dir="ltr">Contributor</bdi> ול־<bdi dir="ltr">Owner</bdi> בלי להקצות אותם.
2. ב־**<bdi dir="ltr">Check access</bdi>** חפשו רק את חשבון הבדיקה. בדקו אם כבר קיימת גישה בירושה מהמינוי. אם כן, אין להסיר אותה; בחרו חשבון אחר שסופק מראש או בצעו קריאה בלבד.
3. **<bdi dir="ltr">Add > Add role assignment</bdi>**: <bdi dir="ltr">Role</bdi> **<bdi dir="ltr">Reader</bdi>** > **<bdi dir="ltr">Next</bdi>**, <bdi dir="ltr">Assign access to</bdi> **<bdi dir="ltr">User</bdi>, <bdi dir="ltr">group</bdi>, <bdi dir="ltr">or service principal</bdi>**, **<bdi dir="ltr">Select members</bdi>** ובחרו את משתמש הבדיקה המדויק > **<bdi dir="ltr">Review + assign</bdi>**. אם קיים מסך <bdi dir="ltr">Assignment type</bdi>, בחרו **<bdi dir="ltr">Active</bdi>**; אין להפעיל <bdi dir="ltr">Eligible/PIM</bdi> לצורך הדגמה זו.
4. ב־**<bdi dir="ltr">Role assignments</bdi>** סננו למשתמש: <bdi dir="ltr">Scope</bdi> צריך להיות **<bdi dir="ltr">This resource</bdi>** / ה־<bdi dir="ltr">RG</bdi> הנוכחי, לא <bdi dir="ltr">Subscription.</bdi> רשמו את ההקצאה שיצרתם.
5. אופציונלי: היכנסו עם חשבון הבדיקה לחלון <bdi dir="ltr">InPrivate.</bdi> המרצה מספק קישור **<bdi dir="ltr">RG > Overview</bdi>** באמצעות כתובת הפורטל של ה־<bdi dir="ltr">RG</bdi>, ללא פרסום מזהי המינוי. לאחר <bdi dir="ltr">propagation</bdi> אמור לראות את <bdi dir="ltr">`vnet-m02-existing`</bdi>.
6. כמשתמש בדיקה, פתחו **<bdi dir="ltr">VNet > Tags</bdi>**, נסו להוסיף <bdi dir="ltr">`ReaderAttempt=ShouldFail`</bdi> ולשמור. פעולה אמורה להיות לא זמינה או להיכשל ב־<bdi dir="ltr">Authorization.</bdi> אם הצליחה, קיימת גישה נוספת — עצרו, בדקו <bdi dir="ltr">Check access</bdi>, ולא מסירים הרשאות מקוריות.
7. חזרו כמרצה ל־**<bdi dir="ltr">RG > Activity log</bdi>**, סננו זמן ופעולות **<bdi dir="ltr">Create role assignment</bdi>** / **<bdi dir="ltr">Delete role assignment</bdi>**. הציגו רק אירועי הדמו; ייתכן עיכוב בתצוגה.

**תוצאה ואימות:** ההקצאה נראית ב־<bdi dir="ltr">Scope</bdi> המדויק, <bdi dir="ltr">Reader</bdi> יכול לקרוא ולא לכתוב. בדיקת <bdi dir="ltr">UI</bdi> ללא כניסה נוספת מוכיחה הגדרת <bdi dir="ltr">Assignment</bdi>, לא הרשאה אפקטיבית.

**נקודת הוראה:** <bdi dir="ltr">RBAC</bdi> הוא מודל הרשאות מצטברות; <bdi dir="ltr">Reader</bdi> לא מבטל <bdi dir="ltr">Contributor</bdi> שהתקבל דרך קבוצה. <bdi dir="ltr">Entra User Administrator</bdi> אינו אותו <bdi dir="ltr">Role</bdi> כמו <bdi dir="ltr">Azure Reader.</bdi>

**תקלות נפוצות:** **<bdi dir="ltr">Add role assignment</bdi>** אפור — חסרה הרשאת <bdi dir="ltr">Authorization</bdi>; אין לבקש <bdi dir="ltr">Owner</bdi> למינוי. משתמש אינו רואה <bdi dir="ltr">RG</bdi> — בדקו <bdi dir="ltr">Tenant</bdi>, <bdi dir="ltr">propagation</bdi> וכניסה מחדש. <bdi dir="ltr">Reader</bdi> אינו בהכרח רשאי לקרוא <bdi dir="ltr">Blob data.</bdi>

**ניקוי:** ב־<bdi dir="ltr">IAM</bdi> הסירו רק הקצאת <bdi dir="ltr">Reader</bdi> שיצרתם למשתמש ב־<bdi dir="ltr">RG</bdi> הזה. אם <bdi dir="ltr">`ReaderAttempt`</bdi> נוצר בגלל הרשאה נוספת, המרצה יסיר את <bdi dir="ltr">Tag</bdi> הבדיקה בלבד. אין למחוק משתמש שסופק מראש.

## הדגמה <bdi dir="ltr">3</bdi> — <bdi dir="ltr">Policy</bdi> מסוג <bdi dir="ltr">Deny</bdi> ו־<bdi dir="ltr">Initiative</bdi>

**מטרה:** לראות <bdi dir="ltr">Enforcement</bdi> בזמן יצירה ולהבדיל בין <bdi dir="ltr">Definition</bdi>, <bdi dir="ltr">Assignment</bdi> ו־<bdi dir="ltr">Compliance.</bdi>

**דרישות:** <bdi dir="ltr">Resource Policy Contributor</bdi>; <bdi dir="ltr">RG</bdi> ו־<bdi dir="ltr">VNet</bdi> קיימים מהדגמה <bdi dir="ltr">1.</bdi> יצירת <bdi dir="ltr">Initiative definition</bdi> דורשת הרשאה מתאימה במינוי — אם חסרה, בצעו רק <bdi dir="ltr">Assignment</bdi> של <bdi dir="ltr">Built-in policy</bdi> ב־<bdi dir="ltr">RG.</bdi>

### צעדים — <bdi dir="ltr">Assignment</bdi> יחיד

1. **<bdi dir="ltr">Policy > Definitions</bdi>**, חפשו <bdi dir="ltr">Built-in</bdi> בשם **<bdi dir="ltr">Require a tag and its value on resources</bdi>**. פתחו את <bdi dir="ltr">JSON</bdi> והצביעו על <bdi dir="ltr">Effect</bdi> מסוג <bdi dir="ltr">`deny`</bdi>.
2. **<bdi dir="ltr">Assign policy</bdi>**: ב־**<bdi dir="ltr">Scope</bdi>** בחרו את מינוי המעבדה ואז **<bdi dir="ltr">Resource group</bdi> = <bdi dir="ltr">rg-az104-m02-demo</bdi>**. <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`m02-require-costcenter`</bdi>, <bdi dir="ltr">Policy enforcement</bdi> **<bdi dir="ltr">Enabled</bdi>**. אין לבחור <bdi dir="ltr">Scope</bdi> של מינוי שלם.
3. ב־**<bdi dir="ltr">Parameters</bdi>** הגדירו <bdi dir="ltr">Tag Name</bdi> <bdi dir="ltr">`CostCenter`</bdi>, <bdi dir="ltr">Tag Value</bdi> <bdi dir="ltr">`AZ104-Class`</bdi>. ב־<bdi dir="ltr">Non-compliance message</bdi> אפשר להזין <bdi dir="ltr">`Demo only: CostCenter is required`</bdi>. אין <bdi dir="ltr">Managed identity</bdi> ל־<bdi dir="ltr">Deny.</bdi> **<bdi dir="ltr">Review + create > Create</bdi>**.
4. המתינו מספר דקות להפצת <bdi dir="ltr">Assignment.</bdi> צרו <bdi dir="ltr">VNet</bdi> בשם <bdi dir="ltr">`vnet-m02-denied`</bdi>, באותו <bdi dir="ltr">RG</bdi> ואזור, <bdi dir="ltr">`10.24.0.0/16`</bdi>, <bdi dir="ltr">Subnet</bdi> <bdi dir="ltr">`snet-demo`</bdi> עם <bdi dir="ltr">`10.24.1.0/24`</bdi>, ללא <bdi dir="ltr">Tags.</bdi> יצירה אמורה להיכשל ב־<bdi dir="ltr">`RequestDisallowedByPolicy`</bdi>.
5. פתחו את פרטי הכשל ובדקו שה־<bdi dir="ltr">Assignment</bdi> החוסם הוא <bdi dir="ltr">`m02-require-costcenter`</bdi>. אם זו <bdi dir="ltr">Policy</bdi> אחרת שירשה המעבדה, אין לשנות אותה. אם ה־<bdi dir="ltr">VNet</bdi> נוצר לפני הפצת המדיניות, אין להציג זאת כהצלחה של <bdi dir="ltr">Deny.</bdi>
6. באותו אשף הוסיפו <bdi dir="ltr">`CostCenter=AZ104-Class`</bdi> וצרו מחדש. בדקו **<bdi dir="ltr">Overview</bdi>** ו־**<bdi dir="ltr">Tags</bdi>** של <bdi dir="ltr">`vnet-m02-denied`</bdi>. אם יצירה מוקדמת הצליחה, הוסיפו לו את ה־<bdi dir="ltr">Tag</bdi> כמרצה במקום למחוק משאבים אחרים.
7. **<bdi dir="ltr">Policy > Compliance</bdi>**, סננו ל־<bdi dir="ltr">Assignment.</bdi> <bdi dir="ltr">`vnet-m02-existing`</bdi> היה ללא <bdi dir="ltr">Tag</bdi> לפני <bdi dir="ltr">Assignment</bdi> ועשוי להופיע <bdi dir="ltr">Non-compliant</bdi> לאחר הערכה. <bdi dir="ltr">Deny</bdi> אינו מוסיף <bdi dir="ltr">Tag</bdi> למשאב קיים.

### הרחבה — <bdi dir="ltr">Initiative</bdi> עם אותו <bdi dir="ltr">Scope</bdi> מוגבל

1. מחקו **רק** <bdi dir="ltr">Assignment</bdi> <bdi dir="ltr">`m02-require-costcenter`</bdi> כדי למנוע שתי הקצאות מיותרות.
2. **<bdi dir="ltr">Policy > Definitions > + Initiative definition</bdi>**: <bdi dir="ltr">Definition location</bdi> מינוי המעבדה, <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`m02-governance-demo`</bdi>, <bdi dir="ltr">Category</bdi> <bdi dir="ltr">`Demo`</bdi>.
3. הוסיפו שתי <bdi dir="ltr">Built-in policies:</bdi> **<bdi dir="ltr">Require a tag and its value on resources</bdi>** ו־**<bdi dir="ltr">Allowed locations</bdi>**.
4. הגדירו <bdi dir="ltr">Parameters</bdi> של ה־<bdi dir="ltr">Tag</bdi> כערכים קבועים <bdi dir="ltr">`CostCenter`</bdi>, <bdi dir="ltr">`AZ104-Class`</bdi>, ואת רשימת המיקומים ל־**<bdi dir="ltr">West Europe</bdi>**. אם הממשק מציע ליצור <bdi dir="ltr">Initiative parameters</bdi>, אפשר במקום זאת להגדיר פרמטרים ולספק ערכים אלה ב־<bdi dir="ltr">Assignment</bdi>; ודאו במסך הסיכום את שני הסטים.
5. שמרו <bdi dir="ltr">Definition ></bdi> **<bdi dir="ltr">Assign initiative</bdi>**. <bdi dir="ltr">Scope</bdi> **רק <bdi dir="ltr">RG</bdi> הדמו**, <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`m02-initiative-assignment`</bdi>, <bdi dir="ltr">Enforcement</bdi> **<bdi dir="ltr">Enabled</bdi>**. בדקו <bdi dir="ltr">Compliance</bdi> של כל <bdi dir="ltr">Policy</bdi> בנפרד; אין צורך לפרוס משאב באזור אחר.

**תוצאה ואימות:** ניסיון יצירה ללא <bdi dir="ltr">Tag</bdi> נחסם לאחר הפצה, ניסיון עם <bdi dir="ltr">Tag</bdi> מותר, ו־<bdi dir="ltr">Initiative</bdi> מאגדת שתי בדיקות. <bdi dir="ltr">Compliance dashboard</bdi> יכול להתעדכן לאחר זמן רב יותר מתגובת <bdi dir="ltr">Deny.</bdi>

**נקודת הוראה:** <bdi dir="ltr">Azure Policy</bdi> בודקת תכונות משאב; <bdi dir="ltr">Azure RBAC</bdi> בודק מי יכול לבצע פעולה. הרשאת <bdi dir="ltr">Contributor</bdi> אינה עוקפת <bdi dir="ltr">Deny.</bdi>

**תקלות נפוצות:** ללא חסימה — בדקו <bdi dir="ltr">Scope</bdi>, <bdi dir="ltr">Enforcement</bdi> ופרמטרים והמתינו להפצה. <bdi dir="ltr">Compliance</bdi> ריק — המתינו לסריקה, אל תייצרו עומס משאבים. <bdi dir="ltr">Resource type</bdi> שאינו תומך <bdi dir="ltr">Tags</bdi> אינו מתאים לתרחיש; <bdi dir="ltr">VNet</bdi> תומך.

**ניקוי:** לפני הדגמה <bdi dir="ltr">4</bdi>, הסירו רק <bdi dir="ltr">Assignments</bdi> של הדמו, כולל <bdi dir="ltr">Initiative assignment.</bdi> מחקו את <bdi dir="ltr">Initiative definition</bdi> <bdi dir="ltr">`m02-governance-demo`</bdi> אחרי הסרת הקצאתו. אין למחוק <bdi dir="ltr">Built-in definitions.</bdi> מחקו רק <bdi dir="ltr">`vnet-m02-denied`</bdi>; השאירו את <bdi dir="ltr">VNet</bdi> הקיים ללא <bdi dir="ltr">CostCenter.</bdi>

## הדגמה <bdi dir="ltr">4</bdi> — <bdi dir="ltr">Inherit tag</bdi> ו־<bdi dir="ltr">Remediation</bdi>, אופציונלי

**מטרה:** לתקן משאב קיים באמצעות <bdi dir="ltr">Modify</bdi>, בניגוד ל־<bdi dir="ltr">Deny</bdi> מהדגמה <bdi dir="ltr">3.</bdi>

**דרישות:** <bdi dir="ltr">RG</bdi> עם <bdi dir="ltr">`CostCenter=AZ104-Class`</bdi>, <bdi dir="ltr">`vnet-m02-existing`</bdi> ללא <bdi dir="ltr">Tag</bdi> זה; אין <bdi dir="ltr">Assignment Deny</bdi> מהדגמה הקודמת. <bdi dir="ltr">Resource Policy Contributor</bdi> וכן <bdi dir="ltr">Role assignment write</bdi> ב־<bdi dir="ltr">RG.</bdi> אם הפורטל מבקש להעניק תפקיד מחוץ ל־<bdi dir="ltr">RG</bdi>, עצרו ועברו לקריאה בלבד.

### צעדים

1. **<bdi dir="ltr">Policy > Definitions</bdi>**: חפשו **<bdi dir="ltr">Inherit a tag from the resource group if missing</bdi>**, פתחו את <bdi dir="ltr">Definition</bdi> ואמתו <bdi dir="ltr">Effect</bdi> <bdi dir="ltr">`modify`</bdi> ו־<bdi dir="ltr">Role definition</bdi> המינימלי שנדרש, בדרך כלל **<bdi dir="ltr">Tag Contributor</bdi>**.
2. <span dir="ltr">**Assign policy**: Scope **rg-az104-m02-demo**, Name `m02-inherit-costcenter`, Parameter Tag Name `CostCenter`.</span>
3. ב־**<bdi dir="ltr">Remediation / Managed identity</bdi>** בחרו **<bdi dir="ltr">Create a managed identity</bdi>**, <bdi dir="ltr">System assigned</bdi>, <bdi dir="ltr">Location</bdi> **<bdi dir="ltr">West Europe</bdi>**. אין צורך ב־<bdi dir="ltr">VM</bdi> או בסיסמה. אל תסמנו יצירת <bdi dir="ltr">Remediation</bdi> אוטומטית אם רוצים להראות את השלב בנפרד.
4. **<bdi dir="ltr">Review + create</bdi>**. ב־**<bdi dir="ltr">RG > IAM</bdi>** אמתו שלזהות ה־<bdi dir="ltr">Assignment</bdi> ניתנה רק ההרשאה הדרושה ב־<bdi dir="ltr">RG.</bdi> הפורטל יכול להעניק אותה אוטומטית רק אם ליוצר יש <bdi dir="ltr">Role assignment write.</bdi> אין להוסיף <bdi dir="ltr">Contributor</bdi> במינוי כפתרון.
5. ב־**<bdi dir="ltr">Policy > Compliance</bdi>** סננו ל־<bdi dir="ltr">Assignment</bdi> וחכו לזיהוי ה־<bdi dir="ltr">VNet</bdi> כ־<bdi dir="ltr">Non-compliant.</bdi> אם הזמן קצר, אפשר להציג את <bdi dir="ltr">Definition</bdi> וה־<bdi dir="ltr">Identity</bdi> ולא לטעון שהמשאב כבר תוקן.
6. **<bdi dir="ltr">Policy > Remediation > Create remediation task</bdi>**: בחרו את <bdi dir="ltr">Assignment</bdi>, <bdi dir="ltr">Scope RG</bdi> זה והאזור **<bdi dir="ltr">West Europe</bdi>**. אם מוצעת אפשרות **<bdi dir="ltr">Re-evaluate resource compliance before remediating</bdi>**, אפשר לבחור בה. ודאו שרשימת המשאבים כוללת רק משאבי הדמו > **<bdi dir="ltr">Remediate</bdi>**.
7. עקבו אחרי <bdi dir="ltr">Task status.</bdi> לאחר הצלחה פתחו **<bdi dir="ltr">vnet-m02-existing > Tags</bdi>**: מצופה <bdi dir="ltr">`CostCenter=AZ104-Class`</bdi>. <bdi dir="ltr">Compliance</bdi> עשוי להשתנות ל־<bdi dir="ltr">Compliant</bdi> רק בהערכה הבאה.

**תוצאה ואימות:** הצלחת <bdi dir="ltr">Task</bdi> ובדיקה ישירה של <bdi dir="ltr">Tag</bdi> הן הוכחת התיקון. <bdi dir="ltr">Pending</bdi> אינו הצלחה; במקרה של זמן ממושך השתמשו במעבדה מוכנה מראש או בתצוגת קריאה.

**נקודת הוראה:** <bdi dir="ltr">Assignment</bdi> של <bdi dir="ltr">Modify</bdi> לא משנה מיד את כל המשאבים הקיימים. <bdi dir="ltr">Remediation</bdi> משתמשת ב־<bdi dir="ltr">Managed identity</bdi> עם הרשאות משלה; היא אינה פועלת בשם הסטודנט.

**תקלות נפוצות:** <bdi dir="ltr">Remediation</bdi> ללא הרשאה — בדקו <bdi dir="ltr">Tag Contributor</bdi> של זהות <bdi dir="ltr">Assignment</bdi> ב־<bdi dir="ltr">RG.</bdi> אין <bdi dir="ltr">Tag</bdi> ב־<bdi dir="ltr">RG</bdi> — הוסיפו את <bdi dir="ltr">Tag</bdi> הדמו. <bdi dir="ltr">Tag</bdi> קיים עם ערך אחר — <bdi dir="ltr">`if missing`</bdi> אינו מחליף אותו.

**ניקוי:** המתינו לסיום <bdi dir="ltr">Task</bdi>, מחקו <bdi dir="ltr">Assignment</bdi> זה בלבד, ובדקו והסירו רק <bdi dir="ltr">Role assignment</bdi> של הזהות שנוצרה לדמו אם נשאר. <bdi dir="ltr">System-assigned identity</bdi> קשורה ל־<bdi dir="ltr">Assignment.</bdi> אין למחוק זהות משותפת. משאבי <bdi dir="ltr">RG</bdi> יימחקו בניקוי הסופי.

## הדגמה <bdi dir="ltr">5</bdi> — היררכיה, <bdi dir="ltr">Quota</bdi> ועלויות

**מטרה:** לחבר <bdi dir="ltr">Scope</bdi> של <bdi dir="ltr">Governance</bdi> למבנה ארגוני ולבקרת עלויות ללא הוצאות יזומות.

**דרישות:** קריאה למינוי ול־<bdi dir="ltr">Quotas</bdi>; <bdi dir="ltr">Cost Management Reader</bdi> לקריאת עלויות, ו־<bdi dir="ltr">Cost Management Contributor</bdi> ב־<bdi dir="ltr">RG</bdi> ליצירת <bdi dir="ltr">Budget</bdi> אם נתמך בסוג המינוי. להצגת <bdi dir="ltr">Management groups</bdi> דרושה הרשאת קריאה קיימת. אין לשנות <bdi dir="ltr">Billing</bdi> הרשאות.

### צעדים

1. **<bdi dir="ltr">Management groups</bdi>**: אם נגיש, הציגו רק ענף המעבדה ואת מקומו מעל <bdi dir="ltr">Subscription.</bdi> אין ליצור <bdi dir="ltr">Top-level group</bdi> או להזיז מינוי; אם אינו נגיש, השתמשו בתרשים בשקופיות <bdi dir="ltr">3</bdi> ו־<bdi dir="ltr">12.</bdi>
2. **<bdi dir="ltr">Subscriptions ></bdi> מינוי המעבדה > <bdi dir="ltr">Usage + quotas</bdi>**, או **<bdi dir="ltr">Quotas > Compute</bdi>**: סננו **<bdi dir="ltr">West Europe</bdi>**. הציגו <bdi dir="ltr">Family quota</bdi> ו־<bdi dir="ltr">Total regional vCPUs</bdi> בקריאה בלבד. אין ללחוץ **<bdi dir="ltr">Request increase</bdi>**.
3. ב־**<bdi dir="ltr">RG > Cost Management > Cost analysis</bdi>**, או דרך **<bdi dir="ltr">Cost Management > Change scope</bdi>** ובחירת <bdi dir="ltr">RG</bdi> הדמו, בחרו <bdi dir="ltr">Current month</bdi> וקיבוץ לפי <bdi dir="ltr">Resource.</bdi> נתונים אפסיים או ריקים ב־<bdi dir="ltr">RG</bdi> חדש הם תקינים.
4. אופציונלי: באותו <bdi dir="ltr">Scope</bdi> בחרו **<bdi dir="ltr">Budgets > Add</bdi>**. <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`budget-m02-demo`</bdi>, <bdi dir="ltr">Reset period</bdi> **<bdi dir="ltr">Monthly</bdi>**, <bdi dir="ltr">Amount</bdi> <bdi dir="ltr">`10`</bdi> במטבע שמוצג בפועל, <bdi dir="ltr">Start date</bdi> תחילת החודש הנוכחי, <bdi dir="ltr">End date</bdi> סוף החודש הבא.
5. ב־<bdi dir="ltr">Alerts</bdi> הגדירו **<bdi dir="ltr">Actual 80</bdi>%** ו־**<bdi dir="ltr">Actual 100</bdi>%**. כתובת <bdi dir="ltr">Notification</bdi> תהיה כתובת מעבדה מאושרת של המרצה, לא כתובת דמה; אין <bdi dir="ltr">Action group.</bdi> אם אין כתובת מאושרת, הציגו את האשף וסגרו בלי <bdi dir="ltr">Create.</bdi>
6. אם יצרתם, פתחו <bdi dir="ltr">Budget</bdi> ואמתו <bdi dir="ltr">Amount</bdi>, <bdi dir="ltr">Thresholds</bdi> ו־<bdi dir="ltr">Scope.</bdi> אין להוציא כסף כדי לבדוק שליחת התראה. נתוני עלות זמינים בדרך כלל לאחר <bdi dir="ltr">8</bdi>–<bdi dir="ltr">24</bdi> שעות והערכה אינה בזמן אמת.
7. ב־**<bdi dir="ltr">Advisor > Cost</bdi>**, רק במינוי המעבדה ואם מורשה, בדקו האם קיימות המלצות. אין להתחייב ל־<bdi dir="ltr">Reservation</bdi>, <bdi dir="ltr">Savings plan</bdi> או <bdi dir="ltr">Hybrid Benefit</bdi>; אין להבטיח המלצה ב־<bdi dir="ltr">RG</bdi> ריק.

**תוצאה ואימות:** <bdi dir="ltr">Quota</bdi> נראית בנפרד מ־<bdi dir="ltr">Budget</bdi>; <bdi dir="ltr">Budget</bdi> שנוצר מציג את ספי ההתראה. אין חיוב <bdi dir="ltr">Compute</bdi> מהמשאבים שבמדריך.

**נקודת הוראה:** <bdi dir="ltr">Budget</bdi> שולח התראות ואינו עוצר משאבים או מגביל צריכה. <bdi dir="ltr">Quota</bdi> היא מגבלת שירות, לא תקציב. <bdi dir="ltr">Tag</bdi> יכול לסייע בפילוח אך אינו תחליף ל־<bdi dir="ltr">Scope.</bdi>

**תקלות נפוצות:** <bdi dir="ltr">Cost analysis</bdi> או <bdi dir="ltr">Budget</bdi> לא זמינים — בדקו הרשאות וסוג הסכם; עברו למסמך הרשמי במקום להרחיב גישה. עלות ריקה — המתינו ל־<bdi dir="ltr">Data refresh</bdi>; אין לייצר צריכה מלאכותית.

**ניקוי:** מחקו רק <bdi dir="ltr">`budget-m02-demo`</bdi> אם נוצר. ודאו שאין עוד <bdi dir="ltr">Policy assignment</bdi>, <bdi dir="ltr">Role assignment</bdi> או <bdi dir="ltr">Lock</bdi> של הדמו. ב־**<bdi dir="ltr">Resource groups > rg-az104-m02-demo > Resources</bdi>** בדקו שאין משאבים שלא יצרתם, ואז **<bdi dir="ltr">Delete resource group</bdi>** עם אישור שם ה־<bdi dir="ltr">RG. Definitions</bdi> ברמת מינוי מנקים בנפרד לפי הדגמה <bdi dir="ltr">3.</bdi>

## מקורות <bdi dir="ltr">Microsoft</bdi>

- [<bdi dir="ltr">Resource groups</bdi> בפורטל](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal)
- [<bdi dir="ltr">Resource locks</bdi> ומגבלותיהם](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources)
- [<bdi dir="ltr">Role assignments</bdi> בפורטל](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal)
- [<bdi dir="ltr">Azure Policy</bdi> — יצירה וניהול](https://learn.microsoft.com/en-us/azure/governance/policy/tutorials/create-and-manage)
- [<bdi dir="ltr">Remediation</bdi> ו־<bdi dir="ltr">Managed identity</bdi>](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources)
- <span dir="ltr">[Management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)</span>
- [<bdi dir="ltr">Budgets</bdi>, התראות ועיכוב נתונים](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-acm-create-budgets)
- [מגבלות ו־<bdi dir="ltr">Quotas</bdi>](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)

</div>
