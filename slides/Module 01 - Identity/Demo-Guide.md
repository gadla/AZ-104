<div dir="rtl" align="right">

# <bdi dir="ltr">Module 01</bdi> — מדריך הדגמות: <bdi dir="ltr">Identity</bdi>

מצגת: [<bdi dir="ltr">AZ-104T00A-ENU-PowerPoint_01.pptx</bdi>](./AZ-104T00A-ENU-PowerPoint_01.pptx).
המספור מתייחס לסדר השקופיות במצגת, כולל השקופיות האופציונליות שאחרי שקופית הסיום. המדריך משלב את נושאי המצגת והערות המרצה; לא נדרשת הדגמה לכל שקופית תאוריה.

## תכנון השיעור וגבולות בטיחות

| הדגמה | שקופיות | זמן משוער | אופי |
|---:|---:|---:|---:|
| <bdi dir="ltr">1. Tenant</bdi>, <bdi dir="ltr">Domains</bdi> ורישיונות | <span dir="ltr">6–9, 17–18</span> | <bdi dir="ltr">10</bdi> דקות | קריאה בלבד |
| <bdi dir="ltr">2.</bdi> משתמש מקומי, <bdi dir="ltr">Guest</bdi> ושחזור משתמש | <span dir="ltr">14–15, 18, 21–22</span> | <bdi dir="ltr">20</bdi> דקות | כתיבה ב־<bdi dir="ltr">Tenant</bdi> מעבדה בלבד |
| <bdi dir="ltr">3. Security group</bdi> וחברות <bdi dir="ltr">Assigned / Dynamic</bdi> | <span dir="ltr">16, 18, 21–22</span> | <bdi dir="ltr">15</bdi>–<bdi dir="ltr">25</bdi> דקות | <bdi dir="ltr">Dynamic</bdi> אופציונלי ומותנה ברישוי |
| <bdi dir="ltr">4. SSPR</bdi> לקבוצת בדיקה | <span dir="ltr">10–11</span> | <bdi dir="ltr">15</bdi>–<bdi dir="ltr">25</bdi> דקות | אופציונלי; חלופת קריאה |

1. השתמשו בחשבונות וב־<bdi dir="ltr">Tenant</bdi> שסופקו למעבדה. ב־[<bdi dir="ltr">Azure portal</bdi>](https://portal.azure.com) פתחו **<bdi dir="ltr">Settings > Directories + subscriptions</bdi>**, ובדקו את שם ה־<bdi dir="ltr">Directory</bdi> ואת המינוי הנבחר. ב־[<bdi dir="ltr">Microsoft Entra admin center</bdi>](https://entra.microsoft.com) בדקו שוב את ה־<bdi dir="ltr">Tenant</bdi> בתפריט החשבון וב־**<bdi dir="ltr">Entra ID > Overview</bdi>**.
2. תפקידי <bdi dir="ltr">Entra ID</bdi> אינם תפקידי <bdi dir="ltr">Azure RBAC:</bdi> הרשאת <bdi dir="ltr">Contributor</bdi> למינוי אינה מאפשרת ליצור משתמשי <bdi dir="ltr">Directory.</bdi> אין צורך ב־<bdi dir="ltr">Resource group</bdi> או <bdi dir="ltr">VM</bdi> למודול זה.
3. אין להוסיף הרשאות <bdi dir="ltr">Tenant-wide</bdi> לצורך ההדגמה. מנהל המעבדה יספק מראש את התפקידים הדרושים; כאשר הם אינם זמינים, משתמשים בחלופת הקריאה. אין לשנות <bdi dir="ltr">Production</bdi>, מדיניות <bdi dir="ltr">MFA</bdi>, <bdi dir="ltr">Conditional Access</bdi> או חשבון מנהל אמיתי.
4. השמות להלן מיועדים למעבדה: <bdi dir="ltr">`az104-m01-user01`</bdi>, <bdi dir="ltr">`AZ104 M01 User01`</bdi>, <bdi dir="ltr">`az104-m01-security`</bdi>, <bdi dir="ltr">`az104-m01-dynamic`</bdi>, <bdi dir="ltr">`az104-m01-sspr`</bdi>. אם שם קיים, בחרו סיומת כיתתית חדשה ורשמו את שמות האובייקטים שיצרתם. אין למחוק אובייקט קיים כדי לפנות שם.
5. אין להקרין סיסמה זמנית, מספר טלפון, כתובת שחזור, <bdi dir="ltr">Tenant ID</bdi> או רשימת משתמשים אמיתית. אין לשמור פרטים אלה במדריך, בצילום מסך משותף או ב־<bdi dir="ltr">Git.</bdi> תצוגת שמות בדיקה בלבד מספיקה.

## הדגמה <bdi dir="ltr">1</bdi> — זיהוי <bdi dir="ltr">Directory</bdi>, דומיינים ורישיונות

**מטרה:** להבחין בין <bdi dir="ltr">Identity</bdi>, <bdi dir="ltr">Tenant</bdi> ו־<bdi dir="ltr">Subscription</bdi>, ולחבר את טבלת הרישוי בשקופית <bdi dir="ltr">9</bdi> לממשק בפועל.

**דרישות והרשאות:** חשבון מעבדה עם גישת קריאה למאפייני <bdi dir="ltr">Directory.</bdi> לצפייה ברישיונות נדרשת הרשאת קריאה מתאימה ב־<bdi dir="ltr">Microsoft 365 admin center</bdi>, למשל <bdi dir="ltr">Global Reader</bdi> שהוקצה מראש. אין ליצור <bdi dir="ltr">Tenant</bdi> או מינוי ואין לקנות <bdi dir="ltr">Trial.</bdi>

### צעדים

1. ב־<bdi dir="ltr">Entra admin center</bdi> פתחו **<bdi dir="ltr">Entra ID > Overview</bdi>**. הצביעו על שם ה־<bdi dir="ltr">Tenant</bdi> בלי להעתיק את מזהיו.
2. פתחו **<bdi dir="ltr">Entra ID > Domain names / Custom domain names</bdi>**. זהו את הדומיין הראשוני עם הסיומת <bdi dir="ltr">`onmicrosoft.com`</bdi>. אין ללחוץ **<bdi dir="ltr">Add custom domain</bdi>** או לשנות <bdi dir="ltr">Primary domain.</bdi>
3. עברו ל־<bdi dir="ltr">Azure portal ></bdi> **<bdi dir="ltr">Subscriptions</bdi>**, עם סינון למינוי המעבדה בלבד. הסבירו שמינוי משמש גבול חיוב ומשאבים; משתמש <bdi dir="ltr">Directory</bdi> יכול להתקיים ללא הרשאת גישה למינוי.
4. אם הוקצתה הרשאת קריאה, ב־[<bdi dir="ltr">Microsoft 365 admin center</bdi>](https://admin.microsoft.com) פתחו **<bdi dir="ltr">Billing > Licenses</bdi>**. הציגו רק מוצרי מעבדה, מספר רישיונות זמינים והבדל בין <bdi dir="ltr">P1</bdi> ל־<bdi dir="ltr">P2.</bdi> אין לפתוח דוחות צריכה של ארגון אמיתי.
5. ב־**<bdi dir="ltr">Users > Active users</bdi>**, אם משתמש בדיקה כבר קיים, פתחו **<bdi dir="ltr">Licenses and apps</bdi>** שלו ללא שמירה. הצביעו על **<bdi dir="ltr">Usage location</bdi>** ועל התלות ברישיון פנוי. ניהול הקצאות רישוי מתבצע כיום ב־<bdi dir="ltr">Microsoft 365 admin center</bdi> או <bdi dir="ltr">Microsoft Graph</bdi>, ולא דרך מסכי ההקצאה הישנים ב־<bdi dir="ltr">Entra.</bdi>

**תוצאה ואימות:** הסטודנטים יכולים לזהות שלושה רכיבים שונים: <bdi dir="ltr">Directory</bdi>, דומיין ראשוני ומינוי. אם רשימת רישיונות אינה נגישה, מסמך הרישוי הרשמי הוא חלופת הקריאה; אין להבטיח שמינוי <bdi dir="ltr">Azure</bdi> כולל <bdi dir="ltr">Microsoft 365.</bdi>

**נקודת הוראה:** <bdi dir="ltr">Assigned group</bdi> חינמית אינה הופכת <bdi dir="ltr">Dynamic membership</bdi>, <bdi dir="ltr">SSPR</bdi> או <bdi dir="ltr">PIM</bdi> לחינמיים. <bdi dir="ltr">PIM</bdi> דורש רישוי מתאים כגון <bdi dir="ltr">Entra ID P2</bdi> או <bdi dir="ltr">Entra ID Governance</bdi> למשתמשים הנכללים בתרחיש; הוא אינו מודגם כאן, ואין להפעיל הרשאות מנהל לצורך המחשה.

**תקלות נפוצות:** <bdi dir="ltr">Directory</bdi> שגוי גורם לכך שהמינוי או הדומיין אינם נראים; חזרו לבורר <bdi dir="ltr">Directory.</bdi> מסך רישיונות ריק יכול לנבוע מחוסר מוצר או הרשאה, לא מתקלה ב־<bdi dir="ltr">Azure.</bdi>

**ניקוי:** אין משאבים או הגדרות שנוצרו; סגרו תצוגות המכילות מידע רגיש.

## הדגמה <bdi dir="ltr">2</bdi> — יצירה, עריכה, <bdi dir="ltr">Guest</bdi> ושחזור

**מטרה:** להדגים את מחזור החיים של משתמש <bdi dir="ltr">Cloud-only</bdi> ואת ההבדל בינו לבין <bdi dir="ltr">B2B Guest.</bdi>

**דרישות והרשאות:** <bdi dir="ltr">User Administrator</bdi> בסביבת מעבדה מאושרת; לא <bdi dir="ltr">Global Administrator.</bdi> יצירת <bdi dir="ltr">Guest</bdi> מותנית במדיניות ההזמנות ובחשבון חיצוני ייעודי של המרצה שקיבל הסכמה. אם המדיניות אינה מאפשרת הזמנה, מדגימים את הטופס בלי לשלוח.

### צעדים

1. ב־**<bdi dir="ltr">Entra ID > Users > All users > New user > Create new user</bdi>** הזינו:
   - <bdi dir="ltr">User principal name:</bdi> <bdi dir="ltr">`az104-m01-user01`</bdi> ובחרו את דומיין המעבדה הקיים <bdi dir="ltr">`onmicrosoft.com`</bdi>.
   - <span dir="ltr">Display name: `AZ104 M01 User01`.</span>
   - <bdi dir="ltr">Account enabled:</bdi> כן. השתמשו בסיסמה שנוצרת או בסוד חד־פעמי לפי מדיניות המעבדה; אין להציגו בכיתה.
2. לחצו **<bdi dir="ltr">Review + create > Create</bdi>**. חפשו את המשתמש בשמו המדויק ופתחו **<bdi dir="ltr">Properties</bdi>**. ודאו <bdi dir="ltr">User type</bdi> מסוג **<bdi dir="ltr">Member</bdi>**.
3. לחצו **<bdi dir="ltr">Edit properties</bdi>** והגדירו <bdi dir="ltr">Department</bdi> ל־<bdi dir="ltr">`AZ104-M01-Lab`</bdi>, <bdi dir="ltr">Job title</bdi> ל־<bdi dir="ltr">`Demo Student`</bdi>. שמרו ובדקו שהערכים מופיעים לאחר <bdi dir="ltr">Refresh.</bdi> אין לשנות מקור סנכרון או משתמש <bdi dir="ltr">On-premises.</bdi>
4. אופציונלי: **<bdi dir="ltr">Users > New user > Invite external user</bdi>**. הזינו את כתובת חשבון הבדיקה החיצוני, <bdi dir="ltr">Display name</bdi> <bdi dir="ltr">`AZ104 M01 Guest01`</bdi>, ושלחו הזמנה רק בהסכמה. אין להשתמש בכתובת דמה ולשלוח אליה דואר.
5. פתחו את ה־<bdi dir="ltr">Guest</bdi> החדש: <bdi dir="ltr">User type</bdi> הוא **<bdi dir="ltr">Guest</bdi>**, ומצב ההזמנה עשוי להיות <bdi dir="ltr">Pending acceptance.</bdi> המרצה יכול לאשר בחלון <bdi dir="ltr">InPrivate</bdi> עם החשבון החיצוני, בהתאם למדיניות <bdi dir="ltr">Cross-tenant</bdi> ו־<bdi dir="ltr">MFA.</bdi> קבלה אינה מובטחת ואינה מעניקה <bdi dir="ltr">Azure RBAC.</bdi>
6. בחרו **רק** <bdi dir="ltr">`AZ104 M01 User01`</bdi> > **<bdi dir="ltr">Delete</bdi>** ואשרו. פתחו **<bdi dir="ltr">Users > Deleted users</bdi>**, בחרו אותו > **<bdi dir="ltr">Restore user</bdi>**. המתינו עד שהוא חוזר ל־<bdi dir="ltr">All users</bdi>; בדקו את <bdi dir="ltr">Department</bdi> ואת מזהה המשתמש בממשק בלי לפרסם אותו.
7. ב־**<bdi dir="ltr">Audit logs</bdi>**, אם מורשה, סננו לפעולות המשתמש שנוצר ולזמן ההדגמה. חפשו <bdi dir="ltr">Create</bdi>, <bdi dir="ltr">Update</bdi>, <bdi dir="ltr">Delete</bdi> ו־<bdi dir="ltr">Restore.</bdi> אין צורך להיכנס כמשתמש כדי ליצור אירוע <bdi dir="ltr">Audit</bdi>; <bdi dir="ltr">Sign-in logs</bdi> הם סוג אירועים אחר.

**תוצאה ואימות:** <bdi dir="ltr">Member</bdi> נוצר ושוחזר, <bdi dir="ltr">Guest</bdi> מוצג בנפרד אם נוצר, ומאפייני בדיקה נשמרים. חלון השחזור הרגיל למשתמש שנמחק הוא <bdi dir="ltr">30</bdi> ימים; אין לבצע <bdi dir="ltr">Permanent delete</bdi> במהלך שיעור.

**נקודת הוראה:** <bdi dir="ltr">Authentication</bdi> ל־<bdi dir="ltr">Tenant</bdi> אינה <bdi dir="ltr">Authorization</bdi> למשאבי <bdi dir="ltr">Azure.</bdi> הזמנת <bdi dir="ltr">Guest</bdi> אינה יצירת סיסמה עבורו ואינה מתן תפקיד למינוי.

**תקלות נפוצות:** <bdi dir="ltr">UPN</bdi> חייב להיות ייחודי ובדומיין מאומת; <bdi dir="ltr">`Insufficient privileges`</bdi> מחייב תפקיד מתאים ממנהל המעבדה ולא העלאת הרשאה עצמית. <bdi dir="ltr">Guest</bdi> שלא קיבל הזמנה: בדקו כתובת ומדיניות עם מנהל המעבדה; לא משנים <bdi dir="ltr">External collaboration settings</bdi> לכל ה־<bdi dir="ltr">Tenant.</bdi>

**ניקוי:** אם עוברים להדגמה <bdi dir="ltr">3</bdi>, השאירו את <bdi dir="ltr">Member</bdi> זמנית. בסיום המודול מחקו רק את <bdi dir="ltr">Member</bdi> ואת <bdi dir="ltr">Guest</bdi> שיצרתם, לפי השם וה־<bdi dir="ltr">UPN</bdi> שרשמתם. אין למחוק את החשבון החיצוני ב־<bdi dir="ltr">Tenant</bdi> שלו או משתמש מעבדה שסופק מראש.

## הדגמה <bdi dir="ltr">3</bdi> — <bdi dir="ltr">Security group</bdi>, <bdi dir="ltr">Owner</bdi> ו־<bdi dir="ltr">Membership</bdi>

**מטרה:** להפריד בין <bdi dir="ltr">Owner</bdi> לחבר קבוצה ולהשוות <bdi dir="ltr">Assigned</bdi> ל־<bdi dir="ltr">Dynamic</bdi> ללא הקצאת הרשאות למשאבים.

**דרישות והרשאות:** <bdi dir="ltr">Groups Administrator</bdi> או הרשאה מאושרת לניהול קבוצת בדיקה; משתמש הדגמה <bdi dir="ltr">2</bdi> קיים. לשינוי <bdi dir="ltr">Department</bdi> נדרש <bdi dir="ltr">User Administrator. Dynamic user</bdi> מחייב כיסוי רישוי <bdi dir="ltr">P1</bdi> או <bdi dir="ltr">Intune for Education</bdi> לכל משתמש ייחודי שנכלל בקבוצות הדינמיות; אין להפעילו כאשר הרישוי אינו זמין.

### צעדים — מסלול <bdi dir="ltr">Assigned</bdi>

1. <span dir="ltr">**Entra ID > Groups > All groups > New group**: Group type **Security**, Name `az104-m01-security`, Description `AZ104 M01 classroom only`.</span>
2. הגדירו <bdi dir="ltr">Membership type</bdi> **<bdi dir="ltr">Assigned</bdi>**. השאירו **<bdi dir="ltr">Microsoft Entra roles can be assigned to the group</bdi>** במצב **<bdi dir="ltr">No</bdi>**; זו אינה קבוצת <bdi dir="ltr">Role-assignable.</bdi>
3. ב־**<bdi dir="ltr">Members</bdi>** הוסיפו רק <bdi dir="ltr">`AZ104 M01 User01`</bdi>. ב־**<bdi dir="ltr">Owners</bdi>** הוסיפו את חשבון המרצה הייעודי למעבדה, לא משתמש <bdi dir="ltr">Production.</bdi> לחצו **<bdi dir="ltr">Create</bdi>**.
4. פתחו את הקבוצה > **<bdi dir="ltr">Members</bdi>** ובדקו שהמשתמש מופיע; ב־**<bdi dir="ltr">Owners</bdi>** בדקו את בעל הקבוצה. <bdi dir="ltr">Owner</bdi> אינו בהכרח <bdi dir="ltr">Member.</bdi>
5. הסירו את <bdi dir="ltr">Member</bdi>, בצעו <bdi dir="ltr">Refresh</bdi>, ואז הוסיפו אותו מחדש. אל תייחסו לקבוצה <bdi dir="ltr">Role assignment</bdi> או <bdi dir="ltr">Enterprise application.</bdi>

### הרחבה אופציונלית — <bdi dir="ltr">Dynamic user</bdi>

1. לאחר אימות רישוי, צרו קבוצה **<bdi dir="ltr">Security</bdi>** בשם <bdi dir="ltr">`az104-m01-dynamic`</bdi>, <bdi dir="ltr">Membership type</bdi> **<bdi dir="ltr">Dynamic User</bdi>**, ולא <bdi dir="ltr">Role-assignable.</bdi>
2. פתחו **<bdi dir="ltr">Add dynamic query > Edit rule syntax</bdi>** והזינו:

   <div dir="ltr" align="right">

   ```text
   (user.department -eq "AZ104-M01-Lab") and (user.userPrincipalName -startsWith "az104-m01-")
   ```

   </div>


3. ב־**<bdi dir="ltr">Validate rules</bdi>**, אם זמין, הוסיפו את משתמש הבדיקה ובדקו התאמה. ודאו שאין משתמשים אחרים שמתאימים לתנאי לפני שמירה; אם יש, השתמשו בסיומת כיתתית ייחודית בשני הערכים.
4. שמרו וצרו. ב־**<bdi dir="ltr">Overview</bdi>** בדקו <bdi dir="ltr">Dynamic rule processing status</bdi>, וב־**<bdi dir="ltr">Members</bdi>** בדקו חברות. עיבוד הוא אסינכרוני ועשוי לחרוג מזמן השיעור; תוצאת <bdi dir="ltr">Validate rule</bdi> אינה הוכחה שהחברות כבר עודכנה.
5. שנו **רק** את <bdi dir="ltr">Department</bdi> של <bdi dir="ltr">Member</bdi> ל־<bdi dir="ltr">`AZ104-M01-Other`</bdi>. לאחר עיבוד הוא אמור לצאת מהקבוצה. אם עדיין מופיע, הציגו את סטטוס העיבוד ולא תוצאה מובטחת.

**תוצאה ואימות:** במסלול <bdi dir="ltr">Assigned</bdi> רואים הוספה והסרה ישירות. במסלול <bdi dir="ltr">Dynamic</bdi> רואים כלל מתאים ומצב עיבוד; חברות בפועל נבדקת בנפרד.

**נקודת הוראה:** לא ניתן להוסיף חבר ידנית לקבוצה דינמית. כל מי שמסוגל לערוך את המאפיין שבכלל יכול להשפיע על חברות, ולכן לא משתמשים בכלל כזה להענקת הרשאות רגישות. <bdi dir="ltr">Microsoft 365 group</bdi> מיועדת גם לשירותי שיתוף; לא ניצור אותה כאן כדי למנוע תלויות ורישוי מיותרים.

**תקלות נפוצות:** <bdi dir="ltr">Dynamic User</bdi> לא זמין — בדקו רישוי והרשאה, והישארו ב־<bdi dir="ltr">Assigned.</bdi> אין חברים — בדקו שגיאת תחביר, <bdi dir="ltr">Department</bdi> מדויק, <bdi dir="ltr">UPN</bdi> וסטטוס עיבוד.

**ניקוי:** מחקו רק <bdi dir="ltr">`az104-m01-dynamic`</bdi> אם נוצרה, ואחריה <bdi dir="ltr">`az104-m01-security`</bdi>, אלא אם השארתם אותה במכוון להדגמת <bdi dir="ltr">RBAC</bdi> במודול <bdi dir="ltr">02.</bdi> אין למחוק קבוצות מובנות או להסיר רישיונות ארגוניים.

## הדגמה <bdi dir="ltr">4</bdi> — <bdi dir="ltr">SSPR</bdi> לקבוצת מעבדה בלבד

**מטרה:** להציג <bdi dir="ltr">Self-service password reset</bdi> תוך הבחנה בין הפעלת <bdi dir="ltr">SSPR</bdi>, זמינות שיטות אימות ורישום המשתמש.

**דרישות והרשאות:** <bdi dir="ltr">Tenant</bdi> ניסוי מבודד, <bdi dir="ltr">Authentication Policy Administrator</bdi>, משתמש <bdi dir="ltr">Cloud-only</bdi> לא־מנהל מהדגמה <bdi dir="ltr">2</bdi>, רישוי שמאפשר <bdi dir="ltr">Password reset</bdi> כגון <bdi dir="ltr">P1</bdi>, וקבוצה <bdi dir="ltr">Assigned</bdi> בשם <bdi dir="ltr">`az104-m01-sspr`</bdi> המכילה **רק** אותו. צרו אותה לפי צעדי הדגמה <bdi dir="ltr">3.</bdi> המשתמש חייב להיות מסוגל להשלים כניסה ראשונה ורישום באמצעות שיטות מאושרות; אין להשתמש במידע שחזור של סטודנטים.

**שער בטיחות:** הגדרות מסוימות ב־<bdi dir="ltr">Password reset</bdi> הן ברמת <bdi dir="ltr">Tenant.</bdi> אם <bdi dir="ltr">SSPR</bdi> כבר בשימוש, או שקבוצת <bdi dir="ltr">Selected</bdi> כבר מוגדרת, **לא משנים דבר**: מציגים <bdi dir="ltr">Properties</bdi>, <bdi dir="ltr">Registration</bdi> ו־<bdi dir="ltr">Authentication methods</bdi> בקריאה בלבד. אין לבחור <bdi dir="ltr">All</bdi>, להחליף קבוצת <bdi dir="ltr">Production</bdi> או להפעיל <bdi dir="ltr">Password writeback.</bdi>

### צעדים — רק ב־<bdi dir="ltr">Tenant</bdi> ניסוי נקי ומאושר

1. רשמו באופן פרטי את המצב המקורי של **<bdi dir="ltr">Entra ID > Password reset > Properties</bdi>** ואת מספר שיטות האימות הנדרש. אם אינו **<bdi dir="ltr">None</bdi>**, עברו לחלופת קריאה.
2. בחרו **<bdi dir="ltr">Selected</bdi>**, ובחרו רק <bdi dir="ltr">`az104-m01-sspr`</bdi> > **<bdi dir="ltr">Save</bdi>**. ודאו שאין חברים אחרים בקבוצה.
3. פתחו **<bdi dir="ltr">Entra ID > Authentication methods > Policies</bdi>**. מאז ספטמבר <bdi dir="ltr">2025</bdi> אין להסתמך על בחירת השיטות במדיניות <bdi dir="ltr">MFA/SSPR</bdi> הישנה. בדקו שהמעבדה מאפשרת למשתמש שיטות שתומכות ב־<bdi dir="ltr">SSPR</bdi>, למשל <bdi dir="ltr">Email</bdi> ו־<bdi dir="ltr">SMS</bdi>, באמצעות מדיניות <bdi dir="ltr">Authentication methods.</bdi> אם צריך להפעיל שיטה, <bdi dir="ltr">Target</bdi> יהיה **<bdi dir="ltr">Select groups</bdi>** ורק קבוצת הבדיקה, בלי לשנות <bdi dir="ltr">Targets</bdi> קיימים.
4. ב־**<bdi dir="ltr">Password reset > Authentication methods</bdi>** בדקו **<bdi dir="ltr">Number of methods required to reset</bdi>**. ב־<bdi dir="ltr">Tenant</bdi> הניסוי בלבד אפשר לבחור <bdi dir="ltr">2</bdi> אם שתי שיטות נתמכות מוכנות. אין לשנות את מדיניות ה־<bdi dir="ltr">Tenant</bdi> הארגוני בשביל הדגמה.
5. בחלון <bdi dir="ltr">InPrivate</bdi> פתחו [<bdi dir="ltr">SSPR setup</bdi>](https://aka.ms/ssprsetup), היכנסו עם משתמש הבדיקה, השלימו שינוי סיסמה ראשונית אם נדרש, ורשמו שתי שיטות מאושרות. המרצה מסתיר מהמסך קודים, טלפון וכתובות.
6. סגרו את החלון. פתחו <bdi dir="ltr">InPrivate</bdi> חדש > [<bdi dir="ltr">Password reset</bdi>](https://aka.ms/sspr). הזינו את <bdi dir="ltr">UPN</bdi> של הבדיקה, השלימו <bdi dir="ltr">CAPTCHA</bdi> ואימות, ובחרו סיסמה חדשה לפי מדיניות.
7. פתחו חלון כניסה חדש וודאו שהסיסמה החדשה מאפשרת כניסה. אם מורשה, בדקו <bdi dir="ltr">Audit logs</bdi> מסוננים למשתמש ולזמן הפעולה בלבד.

**תוצאה ואימות:** איפוס מוצלח רק כאשר המשתמש נכלל ב־<bdi dir="ltr">Scope</bdi>, מכוסה ברישוי ורשום לשיטות הנדרשות. במסלול הקריאה התוצאה היא זיהוי שלושת התנאים, לא איפוס בפועל.

**נקודת הוראה:** שינוי סיסמה כשכבר מחוברים אינו זהה לאיפוס לאחר שכחה. למנהלים חלים כללי איפוס שונים; לכן בודקים משתמש לא־מנהל.

**תקלות נפוצות:** המשתמש אינו זכאי — בדקו רישוי וחברות; אין מספיק שיטות — בדקו <bdi dir="ltr">Registration</bdi> ו־<bdi dir="ltr">Authentication methods policy.</bdi> כשל <bdi dir="ltr">SMS</bdi> או מגבלות <bdi dir="ltr">Tenant:</bdi> עוצרים ומציגים את התנאי החסר, לא מחלישים מדיניות.

**ניקוי:** ב־<bdi dir="ltr">Tenant</bdi> הניסוי בלבד שחזרו את ההגדרות ששיניתם למצב המקורי; הסירו רק <bdi dir="ltr">Target</bdi> של קבוצת הבדיקה משיטות האימות שהוספתם. מחקו את קבוצת <bdi dir="ltr">SSPR</bdi> ואת משתמש הבדיקה בסיום. אין להגדיר <bdi dir="ltr">None</bdi> ב־<bdi dir="ltr">Tenant</bdi> שכבר השתמש ב־<bdi dir="ltr">SSPR.</bdi>

## נושאים אופציונליים שלא נפרסים בכיתה

שקופית <bdi dir="ltr">24</bdi> עוסקת ב־<bdi dir="ltr">Bulk updates:</bdi> אפשר להוריד <bdi dir="ltr">CSV template</bdi> ולהציג את הכותרות בלבד, בלי לייצא משתמשים אמיתיים או לבצע <bdi dir="ltr">Import.</bdi> שקופית <bdi dir="ltr">25</bdi> עוסקת ב־<bdi dir="ltr">Administrative units:</bdi> מציגים את רעיון ה־<bdi dir="ltr">Scope</bdi> והתלות ברישוי; לא מקצים תפקידי <bdi dir="ltr">Tenant.</bdi> במצגת <bdi dir="ltr">25</bdi> שקופיות בפועל.

## מקורות <bdi dir="ltr">Microsoft</bdi>

- [יצירה, הזמנה ומחיקת משתמשים](https://learn.microsoft.com/en-us/entra/fundamentals/how-to-create-delete-users)
- [קבוצות וחברות](https://learn.microsoft.com/en-us/entra/fundamentals/how-to-manage-groups)
- [<bdi dir="ltr">Dynamic membership</bdi> — כללים ורישוי](https://learn.microsoft.com/en-us/entra/identity/users/groups-dynamic-membership)
- [הקצאת רישיונות ב־<bdi dir="ltr">Microsoft 365 admin center</bdi>](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/assign-licenses-to-users)
- [<bdi dir="ltr">SSPR</bdi> — דרישות, <bdi dir="ltr">Scope</bdi> ורישום](https://learn.microsoft.com/en-us/entra/identity/authentication/tutorial-enable-sspr)
- [רישוי <bdi dir="ltr">Entra ID Governance</bdi> ו־<bdi dir="ltr">PIM</bdi>](https://learn.microsoft.com/en-us/entra/id-governance/licensing-fundamentals)
- <span dir="ltr">[Administrative units](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/administrative-units)</span>

</div>
