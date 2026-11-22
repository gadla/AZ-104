<div dir="rtl" align="right">

# <bdi dir="ltr">Module 04</bdi> — מדריך הדגמות: <bdi dir="ltr">Virtual Networking</bdi>

מצגת: [<bdi dir="ltr">AZ-104T00A-ENU-PowerPoint_04.pptx</bdi>](./AZ-104T00A-ENU-PowerPoint_04.pptx), <bdi dir="ltr">43</bdi> שקופיות.
המסלול הראשי מדגים את <bdi dir="ltr">VNet/IP</bdi> בשקופית <bdi dir="ltr">10</bdi>, <bdi dir="ltr">NSG</bdi> בשקופית <bdi dir="ltr">20</bdi> ו־<bdi dir="ltr">DNS</bdi> בשקופית <bdi dir="ltr">28.</bdi> ניתן לבצעו בלי <bdi dir="ltr">VM</bdi>; בדיקות מתוך מערכת הפעלה והצגת <bdi dir="ltr">Effective security rules</bdi> מסומנות כאופציונליות ומצריכות <bdi dir="ltr">VM</bdi> פעיל.

## תוכנית ומשאבים

| הדגמה | שקופיות | זמן | עלות ותלות |
|---:|---:|---:|---:|
| <bdi dir="ltr">1. VNet</bdi>, <bdi dir="ltr">Subnets</bdi> ו־<bdi dir="ltr">Public IP</bdi> | <span dir="ltr">6–10, 40–43</span> | <bdi dir="ltr">15</bdi>–<bdi dir="ltr">20</bdi> דקות | <bdi dir="ltr">VNet</bdi> ללא <bdi dir="ltr">Compute</bdi>; <bdi dir="ltr">Public IP</bdi> אופציונלי ובתשלום |
| <bdi dir="ltr">2. NSG</bdi>, <bdi dir="ltr">ASG</bdi> ו־<bdi dir="ltr">NIC</bdi> | <span dir="ltr">14–20, 31</span> | <bdi dir="ltr">20</bdi> דקות | ללא <bdi dir="ltr">VM</bdi>; <bdi dir="ltr">Effective rules</bdi> אופציונלי |
| <bdi dir="ltr">3. Public DNS zone</bdi> ורשומה | <span dir="ltr">24–26, 28, 34–38</span> | <bdi dir="ltr">15</bdi> דקות | <bdi dir="ltr">Zone</bdi> ושאילתות בתשלום נמוך |
| <bdi dir="ltr">4. Private DNS zone</bdi> ו־<bdi dir="ltr">VNet link</bdi> | <span dir="ltr">27, 31–32, 39</span> | <bdi dir="ltr">15</bdi>–<bdi dir="ltr">25</bdi> דקות | <bdi dir="ltr">VM</bdi> לבדיקה אופציונלי, בתשלום |

1. ב־[<bdi dir="ltr">Azure portal</bdi>](https://portal.azure.com) > **<bdi dir="ltr">Settings > Directories + subscriptions</bdi>** ודאו <bdi dir="ltr">Tenant</bdi> ומינוי מעבדה. בדקו <bdi dir="ltr">Subscription</bdi> גם בכל אשף. אין לחבר <bdi dir="ltr">VNet</bdi> ל־<bdi dir="ltr">Production</bdi> או <bdi dir="ltr">On-premises.</bdi>
2. נדרשת <bdi dir="ltr">Contributor</bdi> ב־<bdi dir="ltr">RG</bdi> ייעודי, <bdi dir="ltr">Network Contributor</bdi> לניהול רשת אם הופרד, ו־<bdi dir="ltr">DNS Zone Contributor / Private DNS Zone Contributor</bdi> עם הרשאות <bdi dir="ltr">Link</bdi> לרשת אם הופרדו התפקידים. אין להעניק הרשאות מינוי חדשות בכיתה.
3. צרו <bdi dir="ltr">RG</bdi> חדש <bdi dir="ltr">`rg-az104-m04-demo`</bdi> באזור **<bdi dir="ltr">West Europe</bdi>**, <bdi dir="ltr">Tag</bdi> <bdi dir="ltr">`DemoOwner=AZ104-M04`</bdi>. אם קיים, בחרו סיומת חדשה ויישמו אותה על כל השמות. אין להשתמש ב־<bdi dir="ltr">`az104-rg4`</bdi> משותף של <bdi dir="ltr">Lab.</bdi>
4. תכנון הכתובות: <bdi dir="ltr">`vnet-m04-demo = 10.20.0.0/16`</bdi>, <bdi dir="ltr">`snet-shared = 10.20.10.0/24`</bdi>, <bdi dir="ltr">`snet-db = 10.20.20.0/24`</bdi>. בדקו עם מנהל המעבדה שאין חפיפה לרשתות שמחברים אליהן. כרגע אין <bdi dir="ltr">Peering.</bdi>
5. בכל אשף <bdi dir="ltr">Network</bdi> השאירו <bdi dir="ltr">Bastion</bdi>, <bdi dir="ltr">Azure Firewall</bdi>, <bdi dir="ltr">DDoS paid plan</bdi>, <bdi dir="ltr">NAT Gateway</bdi> ו־<bdi dir="ltr">Private Resolver</bdi> כבויים. אלה אינם נדרשים למסלול הראשי.
6. <bdi dir="ltr">DNS hosting</bdi> ו־<bdi dir="ltr">Entra custom domain</bdi> הם שירותים שונים. שקופיות <bdi dir="ltr">25/38</bdi> מערבות מושגי <bdi dir="ltr">Domain verification</bdi> של <bdi dir="ltr">Entra:</bdi> יצירת <bdi dir="ltr">Zone</bdi> אינה מאמתת <bdi dir="ltr">Tenant domain</bdi> ואינה רוכשת <bdi dir="ltr">Domain.</bdi> כאן אין שינוי <bdi dir="ltr">Registrar</bdi> או <bdi dir="ltr">DNS</bdi> של ארגון.

## הדגמה <bdi dir="ltr">1</bdi> — <bdi dir="ltr">VNet</bdi>, שתי <bdi dir="ltr">Subnets</bdi> וכתובות

**מטרה:** לראות <bdi dir="ltr">CIDR</bdi>, הפרדת <bdi dir="ltr">Subnets</bdi> ו־<bdi dir="ltr">Allocation</bdi> בלי ליצור <bdi dir="ltr">VM.</bdi>

**דרישות:** <bdi dir="ltr">RG</bdi> חדש והרשאות <bdi dir="ltr">Network</bdi>; <bdi dir="ltr">Public IP</bdi> רק אם המרצה אישר עלות קצרה. משאבים: <bdi dir="ltr">`vnet-m04-demo`</bdi>, ואופציונלית <bdi dir="ltr">`pip-m04-demo`</bdi>.

### צעדים

1. **<bdi dir="ltr">Resource groups > Create</bdi>**: צרו <bdi dir="ltr">RG</bdi> לפי ההכנות.
2. **<bdi dir="ltr">Virtual networks > Create</bdi>**: <bdi dir="ltr">Subscription</bdi> מאושר, <bdi dir="ltr">RG</bdi> הדמו, <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`vnet-m04-demo`</bdi>, <bdi dir="ltr">Region</bdi> **<bdi dir="ltr">West Europe</bdi>**.
3. ב־**<bdi dir="ltr">IP addresses</bdi>** קבעו <bdi dir="ltr">Address space</bdi> <bdi dir="ltr">`10.20.0.0/16`</bdi>. הסירו <bdi dir="ltr">Subnet</bdi> ברירת מחדל אם היא חופפת; צרו:
   - <span dir="ltr">`snet-shared`, Starting address `10.20.10.0`, Size `/24`.</span>
   - <span dir="ltr">`snet-db`, Starting address `10.20.20.0`, Size `/24`.</span>
4. אין <bdi dir="ltr">Service endpoints</bdi>, <bdi dir="ltr">Delegation</bdi> או <bdi dir="ltr">Route table</bdi> בשלב זה. אם מוצגת האפשרות **<bdi dir="ltr">Private subnet / Default outbound access</bdi>**, השאירו <bdi dir="ltr">Private subnet</bdi> במסלול ללא <bdi dir="ltr">VM</bdi>; לא מניחים שקיימת יציאת <bdi dir="ltr">Internet</bdi> אוטומטית.
5. **<bdi dir="ltr">Review + create > Create</bdi>**. ב־**<bdi dir="ltr">VNet > Address space</bdi>** וב־**<bdi dir="ltr">Subnets</bdi>** בדקו את שני הטווחים.
6. חשבו יחד: ב־<bdi dir="ltr">`/24`</bdi> יש <bdi dir="ltr">256</bdi> כתובות, <bdi dir="ltr">Azure</bdi> שומרת את ארבע הראשונות והאחרונה, ולכן <bdi dir="ltr">251</bdi> זמינות. ב־<bdi dir="ltr">`snet-shared`</bdi> הכתובות <bdi dir="ltr">`10.20.10.0`</bdi> עד <bdi dir="ltr">`.3`</bdi> ו־<bdi dir="ltr">`.255`</bdi> שמורות; <bdi dir="ltr">`.4`</bdi> היא הראשונה שניתן להקצות.
7. אפשר לפתוח **+ <bdi dir="ltr">Subnet</bdi>** ולנסות להזין <bdi dir="ltr">`10.20.10.0/25`</bdi> כדי לראות הודעת חפיפה, אך **<bdi dir="ltr">Cancel</bdi>** בלי <bdi dir="ltr">Save.</bdi> אין לשנות את <bdi dir="ltr">Subnet</bdi> הקיימת.
8. אופציונלי: חפשו **<bdi dir="ltr">Public IP addresses > Create</bdi>**. <bdi dir="ltr">RG</bdi> הדמו, <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`pip-m04-demo`</bdi>, <bdi dir="ltr">Region</bdi> **<bdi dir="ltr">West Europe</bdi>**, <bdi dir="ltr">IP version</bdi> **<bdi dir="ltr">IPv4</bdi>**, <bdi dir="ltr">SKU</bdi> **<bdi dir="ltr">Standard</bdi>**, <bdi dir="ltr">Allocation</bdi> **<bdi dir="ltr">Static</bdi>**, <bdi dir="ltr">Tier</bdi> **<bdi dir="ltr">Regional</bdi>**. אם יש בחירת <bdi dir="ltr">Availability zone</bdi>, בחרו **<bdi dir="ltr">No zone</bdi>** כאשר זמין; אחרת אפשר להשאיר ברירת מחדל נתמכת.
9. ב־<bdi dir="ltr">Public IP ></bdi> **<bdi dir="ltr">Overview</bdi>** ודאו שהוקצתה כתובת ו־**<bdi dir="ltr">Associated to</bdi>** ריק. אין לחבר ל־<bdi dir="ltr">NIC</bdi>, ליצור <bdi dir="ltr">Prefix</bdi> או להגדיר <bdi dir="ltr">DNS name label.</bdi>

**תוצאה ואימות:** שתי <bdi dir="ltr">Subnets</bdi> לא חופפות בתוך <bdi dir="ltr">Address space</bdi> אחד. <bdi dir="ltr">Public IP</bdi>, אם נוצר, הוא <bdi dir="ltr">Resource</bdi> נפרד ולא כתובת פרטית של <bdi dir="ltr">VNet.</bdi>

**נקודת הוראה:** <bdi dir="ltr">Subnet</bdi> אינה נהפכת ל־“<bdi dir="ltr">Public</bdi>” רק בגלל השם שלה. <bdi dir="ltr">IP</bdi> פרטי מנוהל ב־<bdi dir="ltr">Azure NIC</bdi>, לא דרך הגדרה ידנית בתוך <bdi dir="ltr">Guest OS.</bdi> דוגמאות <bdi dir="ltr">Dynamic/Basic</bdi> בשקפים ישנים אינן בחירת ה־<bdi dir="ltr">SKU</bdi> להדגמה; משתמשים ב־<bdi dir="ltr">Standard Static.</bdi>

**תקלות נפוצות:** חפיפה — הסירו רק <bdi dir="ltr">Subnet</bdi> לא־שמורה שבאשף או תקנו טווח דמו. <bdi dir="ltr">SKU/Region</bdi> לא זמין — ותרו על <bdi dir="ltr">Public IP</bdi>; אין חובה ליצור אותו. <bdi dir="ltr">DNS label</bdi> תפוס — לא נדרש <bdi dir="ltr">label.</bdi>

**ניקוי:** מחקו מיד רק <bdi dir="ltr">`pip-m04-demo`</bdi> אם נוצר, כי הוא מחויב גם כשהוא לא משויך. השאירו <bdi dir="ltr">RG</bdi> ו־<bdi dir="ltr">VNet</bdi> להמשך; אין למחוק <bdi dir="ltr">VNet</bdi> של מעבדה אחרת.

## הדגמה <bdi dir="ltr">2</bdi> — <bdi dir="ltr">NSG</bdi> ו־<bdi dir="ltr">ASG</bdi> בלי להבטיח בדיקת תעבורה

**מטרה:** להמחיש עדיפות כללים, <bdi dir="ltr">Default rules</bdi> והפרדה בין <bdi dir="ltr">ASG</bdi> לבין <bdi dir="ltr">NSG.</bdi>

**דרישות:** הדגמה <bdi dir="ltr">1</bdi>; <bdi dir="ltr">Network Contributor</bdi> ב־<bdi dir="ltr">RG.</bdi> משאבים: <bdi dir="ltr">`nsg-m04-shared`</bdi>, <bdi dir="ltr">`asg-m04-web`</bdi>, <bdi dir="ltr">`nic-m04-web`</bdi>. אין <bdi dir="ltr">VM</bdi> במסלול הראשי.

### צעדים

1. **<bdi dir="ltr">Network security groups > Create</bdi>**: אותו <bdi dir="ltr">RG</bdi> ואזור, <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`nsg-m04-shared`</bdi>.
2. ב־**<bdi dir="ltr">Inbound security rules</bdi>** הציגו <bdi dir="ltr">Default rules:</bdi> <bdi dir="ltr">`AllowVnetInBound`</bdi>, <bdi dir="ltr">`AllowAzureLoadBalancerInBound`</bdi>, <bdi dir="ltr">`DenyAllInBound`</bdi>. מספר נמוך יותר הוא עדיפות גבוהה יותר; <bdi dir="ltr">Default rules</bdi> אינם ניתנים למחיקה.
3. ב־**<bdi dir="ltr">Outbound security rules</bdi>** הציגו כללי ברירת מחדל. <bdi dir="ltr">Allow</bdi> ב־<bdi dir="ltr">NSG</bdi> אינו יוצר מסלול, <bdi dir="ltr">NAT</bdi> או שירות שמאזין.
4. **<bdi dir="ltr">Application security groups > Create</bdi>**: <bdi dir="ltr">`asg-m04-web`</bdi>, אותו <bdi dir="ltr">RG</bdi> ואזור.
5. **<bdi dir="ltr">Network interfaces > Create</bdi>**: <bdi dir="ltr">`nic-m04-web`</bdi>, <bdi dir="ltr">RG</bdi> הדמו, <bdi dir="ltr">Region</bdi> **<bdi dir="ltr">West Europe</bdi>**, <bdi dir="ltr">VNet</bdi> <bdi dir="ltr">`vnet-m04-demo`</bdi>, <bdi dir="ltr">Subnet</bdi> <bdi dir="ltr">`snet-shared`</bdi>, <bdi dir="ltr">IP version IPv4</bdi>, <bdi dir="ltr">Allocation</bdi> **<bdi dir="ltr">Static</bdi>**, <bdi dir="ltr">Private IP</bdi> <bdi dir="ltr">`10.20.10.4`</bdi>, <bdi dir="ltr">Public IP</bdi> **<bdi dir="ltr">None</bdi>**, <bdi dir="ltr">NSG</bdi> **<bdi dir="ltr">None</bdi>** אם הבחירה מוצעת. לא נדרש <bdi dir="ltr">Accelerated networking.</bdi>
6. פתחו **<bdi dir="ltr">NIC > Application security groups > Configure</bdi>**, בחרו <bdi dir="ltr">`asg-m04-web`</bdi> ושמרו. אם הפורטל אינו מציג בחירה ל־<bdi dir="ltr">NIC</bdi> לא־מחובר, השאירו את הכלל כתרגיל תצורה ללא חברות; לחלופין בצעו את הרחבת <bdi dir="ltr">VM</bdi> בהדגמה <bdi dir="ltr">4</bdi> והוסיפו את <bdi dir="ltr">NIC</bdi> שלו ל־<bdi dir="ltr">ASG.</bdi> אין לטעון שבוצעה בדיקת תעבורה.
7. ב־**<bdi dir="ltr">nsg-m04-shared > Inbound security rules > Add</bdi>** הגדירו:
   - <span dir="ltr">Source **IP Addresses**, Source IP `10.20.20.0/24`, Source port `*`.</span>
   - <span dir="ltr">Destination **Application security group**, Group `asg-m04-web`.</span>
   - <span dir="ltr">Service **Custom**, Destination port `80`, Protocol **TCP**, Action **Allow**.</span>
   - <span dir="ltr">Priority `200`, Name `Allow-DBSubnet-To-Web-HTTP`.</span>
8. הוסיפו כלל נוסף: <bdi dir="ltr">Source</bdi> **<bdi dir="ltr">Service Tag</bdi> = <bdi dir="ltr">VirtualNetwork</bdi>**, <bdi dir="ltr">Destination</bdi> **<bdi dir="ltr">Any</bdi>**, <bdi dir="ltr">Source/Destination port</bdi> <bdi dir="ltr">`*`</bdi>, <bdi dir="ltr">Protocol</bdi> **<bdi dir="ltr">Any</bdi>**, <bdi dir="ltr">Action</bdi> **<bdi dir="ltr">Deny</bdi>**, <bdi dir="ltr">Priority</bdi> <bdi dir="ltr">`300`</bdi>, <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`Deny-Other-VNet-Inbound`</bdi>.
9. **<bdi dir="ltr">NSG > Subnets > Associate</bdi>**: <bdi dir="ltr">VNet</bdi> <bdi dir="ltr">`vnet-m04-demo`</bdi>, <bdi dir="ltr">Subnet</bdi> <bdi dir="ltr">`snet-shared`</bdi>. אל תשייכו ל־<bdi dir="ltr">`snet-db`</bdi>, ואל תוסיפו <bdi dir="ltr">NSG</bdi> נוסף ל־<bdi dir="ltr">NIC.</bdi>
10. הציגו את ההיגיון: <bdi dir="ltr">TCP/80</bdi> מ־<bdi dir="ltr">`snet-db`</bdi> לחבר <bdi dir="ltr">ASG</bdi> מתאים לכלל <bdi dir="ltr">200</bdi>; תעבורת <bdi dir="ltr">VNet</bdi> אחרת תיחסם ב־<bdi dir="ltr">300</bdi> לפני <bdi dir="ltr">AllowVnetInBound</bdi> של ברירת המחדל.

**תוצאה ואימות:** ב־<bdi dir="ltr">NSG</bdi> מופיעים שני הכללים וה־<bdi dir="ltr">Subnet association</bdi>; ב־<bdi dir="ltr">NIC</bdi> מופיעה חברות <bdi dir="ltr">ASG</bdi> אם הממשק מאפשר. זו הוכחת תצורה, **לא** הוכחה ש־<bdi dir="ltr">HTTP</bdi> מגיב: אין <bdi dir="ltr">Web server</bdi> או <bdi dir="ltr">VM</bdi> במסלול הראשי.

**הרחבה אופציונלית — <bdi dir="ltr">Effective security rules:</bdi>** לאחר יצירת <bdi dir="ltr">VM</bdi> המעבדה המתוארת בהדגמה <bdi dir="ltr">4</bdi>, ודאו **<bdi dir="ltr">Running</bdi>**, הוסיפו את ה־<bdi dir="ltr">NIC</bdi> שלו ל־<bdi dir="ltr">ASG</bdi> ובדקו **<bdi dir="ltr">NIC > Effective security rules</bdi>**. <bdi dir="ltr">NSG</bdi> של <bdi dir="ltr">Subnet</bdi> ושל <bdi dir="ltr">NIC</bdi>, אם שניהם קיימים, נבדקים בנפרד; תעבורה חייבת להיות מותרת בשניהם. אין צורך ליצור <bdi dir="ltr">NSG</bdi> שני רק כדי לראות את המסך.

**נקודת הוראה:** <bdi dir="ltr">ASG</bdi> מקבצת <bdi dir="ltr">NIC IP configurations</bdi>; היא אינה <bdi dir="ltr">Firewall</bdi> בפני עצמה. <bdi dir="ltr">Source</bdi> ו־<bdi dir="ltr">Destination ASGs</bdi> באותו כלל חייבים לעמוד במגבלות <bdi dir="ltr">VNet</bdi> של <bdi dir="ltr">ASG. Service tag</bdi> מנוהל על ידי <bdi dir="ltr">Microsoft</bdi> ואינו זהה לקבוצה שיצרתם.

**תקלות נפוצות:** <bdi dir="ltr">Effective rules</bdi> ריק ל־<bdi dir="ltr">NIC</bdi> עצמאי — נדרש <bdi dir="ltr">NIC</bdi> מחובר ל־<bdi dir="ltr">VM</bdi> פעיל. בחירת <bdi dir="ltr">ASG</bdi> לא זמינה — בדקו אזור/<bdi dir="ltr">VNet</bdi> ו־<bdi dir="ltr">NIC. HTTP</bdi> נכשל — צפוי בלי שרת; אין לפתוח <bdi dir="ltr">Internet/SSH</bdi> כדי “לתקן”.

**ניקוי:** אם אין הרחבת <bdi dir="ltr">VM</bdi>, אפשר להשאיר את <bdi dir="ltr">NSG</bdi> עד סיום המודול. לניקוי נפרד: **<bdi dir="ltr">NSG > Subnets</bdi>** הסירו את השיוך מה־<bdi dir="ltr">Subnet</bdi>, הסירו חברות <bdi dir="ltr">ASG</bdi> מה־<bdi dir="ltr">NIC</bdi> ואז מחקו רק <bdi dir="ltr">NIC</bdi>, <bdi dir="ltr">ASG</bdi> ו־<bdi dir="ltr">NSG</bdi> של הדמו. אל תמחקו <bdi dir="ltr">NIC</bdi> של <bdi dir="ltr">VM</bdi> לפני מחיקת <bdi dir="ltr">VM</bdi> הדמו.

## הדגמה <bdi dir="ltr">3</bdi> — <bdi dir="ltr">Public DNS zone</bdi> ללא רכישת <bdi dir="ltr">Domain</bdi>

**מטרה:** ליצור <bdi dir="ltr">Record set</bdi> ולבדוק אותו מול ה־<bdi dir="ltr">Authoritative name server</bdi> בלי <bdi dir="ltr">Delegation.</bdi>

**דרישות:** <bdi dir="ltr">DNS Zone Contributor</bdi> ב־<bdi dir="ltr">RG</bdi>; <bdi dir="ltr">PowerShell</bdi> מקומי עם <bdi dir="ltr">`nslookup`</bdi>, או <bdi dir="ltr">Cloud Shell</bdi> עם אותו כלי. <bdi dir="ltr">Zone</bdi> ושאילתות עשויות להיות מחויבות. אין צורך להיות בעלים של <bdi dir="ltr">Domain</bdi> כדי ליצור <bdi dir="ltr">Zone</bdi>, אך <bdi dir="ltr">Delegation</bdi> אמיתי דורש בעלות.

### צעדים

1. **<bdi dir="ltr">DNS zones > Create</bdi>**: <bdi dir="ltr">RG</bdi> <bdi dir="ltr">`rg-az104-m04-demo`</bdi>, <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`m04-demo.example.com`</bdi>, ללא <bdi dir="ltr">Parent zone linking.</bdi> <bdi dir="ltr">`example.com`</bdi> הוא <bdi dir="ltr">Domain</bdi> שמור לדוגמאות; **אין** לבצע <bdi dir="ltr">Delegation</bdi> שלו.
2. פתחו **<bdi dir="ltr">Overview</bdi>** ורשמו זמנית <bdi dir="ltr">Name server</bdi> אחד מתוך ארבעת שרתי ה־<bdi dir="ltr">NS</bdi> שהוקצו **ל־<bdi dir="ltr">Zone</bdi> הזה**. אין לנחש מספר שרת או להשתמש בשרת של <bdi dir="ltr">Zone</bdi> אחר.
3. **<bdi dir="ltr">Recordsets > + Add / + Record set</bdi>**: <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`www`</bdi>, <bdi dir="ltr">Type</bdi> **<bdi dir="ltr">A</bdi>**, <bdi dir="ltr">TTL</bdi> <bdi dir="ltr">`60`</bdi> <bdi dir="ltr">Seconds</bdi>, <bdi dir="ltr">IP address</bdi> <bdi dir="ltr">`192.0.2.10`</bdi> > **<bdi dir="ltr">Save</bdi>**. זו כתובת <bdi dir="ltr">TEST-NET</bdi> לתיעוד, לא אתר נגיש.
4. הוסיפו <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`alias`</bdi>, <bdi dir="ltr">Type</bdi> **<bdi dir="ltr">CNAME</bdi>**, <bdi dir="ltr">TTL</bdi> <bdi dir="ltr">`60`</bdi>, <bdi dir="ltr">Alias</bdi> <bdi dir="ltr">`www.m04-demo.example.com`</bdi> > **<bdi dir="ltr">Save</bdi>**. אם הממשק דורש <bdi dir="ltr">FQDN</bdi> עם נקודה בסוף, השתמשו <bdi dir="ltr">`www.m04-demo.example.com.`</bdi>.
5. במסוף מקומי החליפו רק את שרת ה־<bdi dir="ltr">NS</bdi> בשרת שהועתק מה־<bdi dir="ltr">Zone:</bdi>

   <div dir="ltr" align="right">

   ```powershell
   nslookup -type=A www.m04-demo.example.com <AZURE-NS-FROM-THIS-ZONE>
   nslookup -type=CNAME alias.m04-demo.example.com <AZURE-NS-FROM-THIS-ZONE>
   ```

   </div>


6. חזרו על שאילתת <bdi dir="ltr">A</bdi> בלי שרת מפורש:

   <div dir="ltr" align="right">

   ```powershell
   nslookup www.m04-demo.example.com
   ```

   </div>


   <bdi dir="ltr">Resolver</bdi> רגיל אינו אמור למצוא את רשומת הדמו כי לא בוצעה <bdi dir="ltr">Delegation.</bdi> אין צורך שהשאילתה הזו תיכשל דווקא ב־<bdi dir="ltr">NXDOMAIN</bdi> כדי להוכיח את הדמו; הוכחת הרשומה היא תשובת ה־<bdi dir="ltr">NS</bdi> הספציפי.

**תוצאה ואימות:** מהשרת <bdi dir="ltr">Authoritative</bdi> מצופה <bdi dir="ltr">A</bdi> עם <bdi dir="ltr">`192.0.2.10`</bdi> ו־<bdi dir="ltr">CNAME</bdi> שמצביע ל־<bdi dir="ltr">www.</bdi> אין לגלוש לכתובת או לטעון שקיים <bdi dir="ltr">Web server.</bdi>

**נקודת הוראה:** <bdi dir="ltr">DNS zone</bdi> אינה <bdi dir="ltr">Domain registration.</bdi> יצירה בפורטל לא מעדכנת <bdi dir="ltr">Registrar.</bdi> בדומיין אמיתי שבבעלותנו משתמשים בכל ארבעת <bdi dir="ltr">NS</bdi> להאצלה; כאן אין שינוי <bdi dir="ltr">DNS</bdi> חיצוני.

**תקלות נפוצות:** <bdi dir="ltr">Timeout</bdi> — רשת הכיתה עשויה לחסום <bdi dir="ltr">DNS</bdi> ישיר החוצה; השתמשו במסוף מעבדה מאושר או בדקו <bdi dir="ltr">Recordsets</bdi> בפורטל. <bdi dir="ltr">NXDOMAIN</bdi> בשרת <bdi dir="ltr">Azure</bdi> — בדקו <bdi dir="ltr">FQDN</bdi> ושרת <bdi dir="ltr">NS</bdi> של <bdi dir="ltr">Zone</bdi> זה, ואז המתינו להפצה.

**ניקוי:** מחקו רק <bdi dir="ltr">`m04-demo.example.com`</bdi> בתוך <bdi dir="ltr">RG</bdi> הדמו או השאירו עד ניקוי <bdi dir="ltr">RG.</bdi> אין לשנות <bdi dir="ltr">Parent zone</bdi>, <bdi dir="ltr">Registrar</bdi> או <bdi dir="ltr">Custom domains</bdi> של <bdi dir="ltr">Entra.</bdi>

## הדגמה <bdi dir="ltr">4</bdi> — <bdi dir="ltr">Private DNS</bdi> ו־<bdi dir="ltr">Link</bdi> לרשת

**מטרה:** לראות ש־<bdi dir="ltr">Private zone</bdi> נחשפת לרשתות מקושרות ולא ל־<bdi dir="ltr">Resolver</bdi> הציבורי.

**דרישות:** <bdi dir="ltr">VNet</bdi> מהדגמה <bdi dir="ltr">1</bdi> והרשאות <bdi dir="ltr">Private DNS</bdi> ו־<bdi dir="ltr">VNet link.</bdi> מסלול התצורה אינו דורש <bdi dir="ltr">VM.</bdi> להוכחת <bdi dir="ltr">Resolution</bdi> מתוך הרשת צריך <bdi dir="ltr">VM</bdi> פעיל עם <bdi dir="ltr">Azure-provided DNS</bdi>; <bdi dir="ltr">Cloud Shell</bdi> רגיל **אינו** בתוך <bdi dir="ltr">VNet</bdi> הדמו.

### צעדים — מסלול תצורה זול

1. **<bdi dir="ltr">Private DNS zones > Create</bdi>**: <bdi dir="ltr">RG</bdi> הדמו, <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`m04-demo.internal`</bdi>.
2. ב־**<bdi dir="ltr">Virtual network links > Add</bdi>**: <bdi dir="ltr">Link name</bdi> <bdi dir="ltr">`link-m04-demo`</bdi>, <bdi dir="ltr">Subscription</bdi> מאושר, <bdi dir="ltr">VNet</bdi> <bdi dir="ltr">`vnet-m04-demo`</bdi>. השאירו **<bdi dir="ltr">Enable auto registration</bdi>** כבוי כדי להציג רשומה ידנית בלבד.
3. שמרו ובדקו <bdi dir="ltr">Link status</bdi> תקין לאחר השלמת הפעולה.
4. **<bdi dir="ltr">Recordsets > Add</bdi>**: <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`web`</bdi>, <bdi dir="ltr">Type</bdi> **<bdi dir="ltr">A</bdi>**, <bdi dir="ltr">TTL</bdi> <bdi dir="ltr">`60`</bdi>, <bdi dir="ltr">IP</bdi> <bdi dir="ltr">`10.20.10.4`</bdi>. זוהי כתובת <bdi dir="ltr">NIC</bdi> הדמו מהדגמה <bdi dir="ltr">2</bdi>; אם <bdi dir="ltr">NIC</bdi> לא נוצר, זו רשומת תרגול בלבד ולא <bdi dir="ltr">Endpoint</bdi> פעיל.
5. בדקו **<bdi dir="ltr">VNet > DNS servers</bdi>**: השאירו **<bdi dir="ltr">Default</bdi> (<bdi dir="ltr">Azure-provided</bdi>)**. אין לשנות שרת <bdi dir="ltr">DNS</bdi> ארגוני. ב־<bdi dir="ltr">Resolver</bdi> המקומי שאילתה <bdi dir="ltr">`nslookup web.m04-demo.internal`</bdi> אינה מוכיחה גישה לרשת הפרטית ואינה אמורה לקבל את רשומת <bdi dir="ltr">Azure</bdi> זו.

### הרחבה אופציונלית — <bdi dir="ltr">VM</bdi> זמני לבדיקת <bdi dir="ltr">DNS</bdi> ו־<bdi dir="ltr">Effective rules</bdi>

המסלול עולה כסף ודורש <bdi dir="ltr">Compute quota</bdi>, זמינות <bdi dir="ltr">SKU</bdi> והרשאת <bdi dir="ltr">Virtual machine Contributor.</bdi> אם אינו מאושר, הסתפקו ב־<bdi dir="ltr">Zone</bdi>, <bdi dir="ltr">Record</bdi> ו־<bdi dir="ltr">Link</bdi>; אין לטעון שנבדקה <bdi dir="ltr">Resolution.</bdi>

1. **<bdi dir="ltr">Virtual machines > Create > Azure virtual machine</bdi>**: <bdi dir="ltr">RG</bdi> הדמו, <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`vm-m04-dns`</bdi>, <bdi dir="ltr">Region</bdi> **<bdi dir="ltr">West Europe</bdi>**, <bdi dir="ltr">Availability</bdi> **<bdi dir="ltr">No infrastructure redundancy required</bdi>**, <bdi dir="ltr">Image</bdi> **<bdi dir="ltr">Ubuntu Server 22.04 LTS x64 Gen2</bdi>**, <bdi dir="ltr">Size</bdi> **<bdi dir="ltr">Standard_B1s</bdi>** אם זמין. אין להתחייב ל־<bdi dir="ltr">Reservation</bdi>; אם <bdi dir="ltr">SKU</bdi> חסום, מנהל המעבדה יבחר גודל קטן מאושר לפני השיעור.
2. <bdi dir="ltr">Authentication type</bdi> **<bdi dir="ltr">SSH public key</bdi>**, <bdi dir="ltr">Username</bdi> <bdi dir="ltr">`azureadmin`</bdi>, השתמשו במפתח מעבדה קיים או <bdi dir="ltr">Generated key</bdi> שמור אצל המרצה בלבד. **<bdi dir="ltr">Public inbound ports</bdi> = <bdi dir="ltr">None</bdi>**. אין להדפיס <bdi dir="ltr">Private key</bdi> או להכניסו למסמך.
3. **<bdi dir="ltr">Disks</bdi>**: <bdi dir="ltr">Standard SSD LRS</bdi> קטן לפי ברירת המחדל הנתמכת של התמונה, ללא <bdi dir="ltr">Data disks.</bdi>
4. **<bdi dir="ltr">Networking</bdi>**: <bdi dir="ltr">VNet</bdi> <bdi dir="ltr">`vnet-m04-demo`</bdi>, <bdi dir="ltr">Subnet</bdi> <bdi dir="ltr">`snet-shared`</bdi>, <bdi dir="ltr">Public IP</bdi> **<bdi dir="ltr">Create new</bdi>** בשם <bdi dir="ltr">`pip-m04-dns`</bdi>, <bdi dir="ltr">SKU</bdi> **<bdi dir="ltr">Standard Static</bdi>**, <bdi dir="ltr">NIC NSG</bdi> **<bdi dir="ltr">None</bdi>** כי <bdi dir="ltr">NSG</bdi> משויך ל־<bdi dir="ltr">Subnet.</bdi> אין <bdi dir="ltr">Bastion</bdi>, <bdi dir="ltr">Load balancer</bdi> או <bdi dir="ltr">NAT Gateway.</bdi>
5. <bdi dir="ltr">Public IP</bdi> כאן נדרש ליציאה מפורשת עבור <bdi dir="ltr">VM Agent</bdi> ו־<bdi dir="ltr">Run Command</bdi>; הוא אינו נדרש ל־<bdi dir="ltr">Private DNS</bdi> עצמו. אין לפתוח פורט נכנס. בדקו <bdi dir="ltr">Outbound rules</bdi> שלא נוספה חסימת <bdi dir="ltr">HTTPS</bdi> של <bdi dir="ltr">Agent.</bdi>
6. **<bdi dir="ltr">Management/Monitoring</bdi>**: אל תפעילו <bdi dir="ltr">Auto-shutdown</bdi> במקום ניקוי, <bdi dir="ltr">Backup</bdi> או שירותים בתשלום שאינם נחוצים. **<bdi dir="ltr">Review + create > Create</bdi>**. אין להשתמש ב־<bdi dir="ltr">NIC</bdi> העצמאי <bdi dir="ltr">`nic-m04-web`</bdi>; האשף יוצר <bdi dir="ltr">NIC</bdi> חדש.
7. לאחר **<bdi dir="ltr">Running</bdi>**, פתחו **<bdi dir="ltr">VM > Networking / Network settings</bdi>** וזהו את <bdi dir="ltr">NIC</bdi> החדש. הוסיפו אותו ל־<bdi dir="ltr">`asg-m04-web`</bdi> דרך **<bdi dir="ltr">NIC > Application security groups</bdi>**. כעת אפשר לפתוח **<bdi dir="ltr">Effective security rules</bdi>** לפי הדגמה <bdi dir="ltr">2.</bdi>
8. ב־**<bdi dir="ltr">NIC > IP configurations > ipconfig1</bdi>** בדקו את כתובת ה־<bdi dir="ltr">IP</bdi> הפרטית שהוקצתה. <bdi dir="ltr">`.4`</bdi> תפוסה על ידי <bdi dir="ltr">NIC</bdi> העצמאי אם נוצר; **אל תנחשו** את כתובת <bdi dir="ltr">VM.</bdi>
9. הוסיפו ל־<bdi dir="ltr">Private zone</bdi> רשומת <bdi dir="ltr">A</bdi> בשם <bdi dir="ltr">`probe`</bdi>, <bdi dir="ltr">TTL</bdi> <bdi dir="ltr">`60`</bdi>, עם **כתובת <bdi dir="ltr">VM</bdi> שהועתקה**.
10. <span dir="ltr">**VM > Run command > RunShellScript**:</span>

    <div dir="ltr" align="right">

    ```bash
    nslookup probe.m04-demo.internal
    ```

    </div>


    מצופה תשובה עם <bdi dir="ltr">IP</bdi> ה־<bdi dir="ltr">VM.</bdi> אם <bdi dir="ltr">`nslookup`</bdi> אינו מותקן, <bdi dir="ltr">RunShellScript</bdi> יכול להשתמש בלי התקנת חבילות:

    <div dir="ltr" align="right">

    ```bash
    getent ahostsv4 probe.m04-demo.internal
    ```

    </div>


11. אופציונלי לקריאה בלבד: הציגו את **<bdi dir="ltr">Enable auto registration</bdi>** ב־<bdi dir="ltr">VNet link.</bdi> השאירו אותו כבוי; <bdi dir="ltr">Auto-registration</bdi> נועדה לרישום <bdi dir="ltr">VM</bdi> ואינה יוצרת אוטומטית כל רשומת שירות שרוצים.

**תוצאה ואימות:** במסלול הראשי <bdi dir="ltr">Zone</bdi>, <bdi dir="ltr">Record</bdi> ו־<bdi dir="ltr">Link</bdi> קיימים. בהרחבה, שאילתה מתוך <bdi dir="ltr">VM</bdi> מחזירה את כתובתו הפרטית. תשובה מ־<bdi dir="ltr">DNS</bdi> אינה מוכיחה שה־<bdi dir="ltr">VM</bdi> מקבל <bdi dir="ltr">HTTP</bdi> או <bdi dir="ltr">Ping.</bdi>

**נקודת הוראה:** <bdi dir="ltr">Peering</bdi> לבדו אינו קישור <bdi dir="ltr">Private DNS</bdi>; נדרשים <bdi dir="ltr">Links</bdi> או פתרון <bdi dir="ltr">DNS</bdi> מתאים. לקוח <bdi dir="ltr">On-premises</bdi> צריך <bdi dir="ltr">DNS forwarding/resolver</bdi> וקישור רשת; לא נפרוס <bdi dir="ltr">Private Resolver</bdi>, <bdi dir="ltr">VPN</bdi> או <bdi dir="ltr">ExpressRoute</bdi> במודול זה.

**תקלות נפוצות:** <bdi dir="ltr">Run Command</bdi> תקוע — בדקו <bdi dir="ltr">VM Agent</bdi> ויציאת <bdi dir="ltr">HTTPS</bdi> מפורשת; לא פותחים <bdi dir="ltr">SSH</bdi> ל־<bdi dir="ltr">Internet. DNS</bdi> לא נפתר — בדקו <bdi dir="ltr">Link</bdi>, <bdi dir="ltr">FQDN</bdi>, <bdi dir="ltr">Azure-provided DNS</bdi> וכתובת <bdi dir="ltr">Record.</bdi> אל תבדקו <bdi dir="ltr">Private zone</bdi> מתוך <bdi dir="ltr">Cloud Shell</bdi> רגיל.

**ניקוי:** אם נוצר <bdi dir="ltr">VM</bdi>, מחקו אותו ואת <bdi dir="ltr">NIC</bdi>, <bdi dir="ltr">OS disk</bdi> ו־<bdi dir="ltr">Public IP</bdi> שיצר האשף, או מחקו את <bdi dir="ltr">RG</bdi> הבלעדי אחרי בדיקת רשימת המשאבים. <bdi dir="ltr">Stop</bdi> (<bdi dir="ltr">deallocated</bdi>) חוסך <bdi dir="ltr">Compute</bdi> אך אינו מבטל חיוב <bdi dir="ltr">Disk/Public IP/DNS.</bdi> הסירו רק <bdi dir="ltr">Link</bdi> ורשומות הדמו, ואז מחקו את <bdi dir="ltr">Private zone.</bdi> בסיום המודול, ודאו <bdi dir="ltr">Tenant</bdi> ומינוי, שאין משאבים זרים ב־<bdi dir="ltr">RG</bdi>, ובצעו **<bdi dir="ltr">Delete resource group</bdi>** רק ל־<bdi dir="ltr">`rg-az104-m04-demo`</bdi>.

## מקורות <bdi dir="ltr">Microsoft</bdi>

- [<bdi dir="ltr">Virtual network concepts</bdi> וכתובות שמורות](https://learn.microsoft.com/en-us/azure/virtual-network/concepts-and-best-practices)
- [<bdi dir="ltr">Public IP</bdi> — <bdi dir="ltr">SKUs</bdi> והקצאה](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses)
- [<bdi dir="ltr">Default outbound access</bdi> והצורך ביציאה מפורשת](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/default-outbound-access)
- [ניהול <bdi dir="ltr">NSG</bdi>](https://learn.microsoft.com/en-us/azure/virtual-network/manage-network-security-group)
- [<bdi dir="ltr">Application security groups</bdi> ומגבלות](https://learn.microsoft.com/en-us/azure/virtual-network/application-security-groups)
- <span dir="ltr">[Effective security rules](https://learn.microsoft.com/en-us/azure/virtual-network/manage-network-security-group#view-effective-security-rules)</span>
- [<bdi dir="ltr">Public DNS zone</bdi> ו־<bdi dir="ltr">Record</bdi> בפורטל](https://learn.microsoft.com/en-us/azure/dns/dns-getstarted-portal)
- [<bdi dir="ltr">Private DNS zone</bdi> ו־<bdi dir="ltr">VNet link</bdi>](https://learn.microsoft.com/en-us/azure/dns/private-dns-getstarted-portal)
- [<bdi dir="ltr">Run Command</bdi> ב־<bdi dir="ltr">Linux</bdi>](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/run-command)

</div>
