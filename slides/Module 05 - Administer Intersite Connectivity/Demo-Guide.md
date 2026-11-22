<div dir="rtl" align="right">

# <bdi dir="ltr">Module 05</bdi> — מדריך נלווה והדגמות נוספות: <bdi dir="ltr">Intersite Connectivity</bdi>

מצגת: [<bdi dir="ltr">AZ-104T00A-ENU-PowerPoint_05.pptx</bdi>](./AZ-104T00A-ENU-PowerPoint_05.pptx), <bdi dir="ltr">27</bdi> שקופיות.
הדמו הקיים [<bdi dir="ltr">demo.md</bdi> — <bdi dir="ltr">VNet peering</bdi>, <bdi dir="ltr">NVA and UDRs</bdi>](./demo.md), [<bdi dir="ltr">deploy.ps1</bdi>](./deploy.ps1) ו־[<bdi dir="ltr">main.bicep</bdi>](./main.bicep) נשארים ללא שינוי. מדריך זה מוסיף מסלול <bdi dir="ltr">Portal</bdi> זול, הקשר לשקופיות, בדיקות בטיחות והדגמת <bdi dir="ltr">Endpoints</bdi>; הוא אינו מחליף את הדמו הקיים.

## תכנון השיעור

| הדגמה | שקופיות | זמן | מסלול |
|---:|---:|---:|---:|
| <bdi dir="ltr">1. Peering</bdi> דו־כיווני | <span dir="ltr">6–10, 24–25</span> | <bdi dir="ltr">15</bdi> דקות | שני <bdi dir="ltr">VNets</bdi> ריקים, ללא <bdi dir="ltr">VM</bdi> |
| <bdi dir="ltr">2. Route table</bdi> ו־<bdi dir="ltr">UDR</bdi> מסוג <bdi dir="ltr">None</bdi> | <span dir="ltr">14–16, 24</span> | <bdi dir="ltr">15</bdi> דקות | אותה רשת; בדיקת תצורה |
| <bdi dir="ltr">3. Non-transitive peering</bdi> ו־<bdi dir="ltr">NVA</bdi> | <span dir="ltr">7–9, 14–16, 24</span> | <bdi dir="ltr">25</bdi>–<bdi dir="ltr">35</bdi> דקות ועוד <bdi dir="ltr">15</bdi>–<bdi dir="ltr">30</bdi> להכנה | הרחבה אופציונלית בתשלום של הדמו הקיים |
| <bdi dir="ltr">4. Service endpoint</bdi> מול <bdi dir="ltr">Private endpoint</bdi> | <span dir="ltr">17–20, 27</span> | <bdi dir="ltr">25</bdi>–<bdi dir="ltr">35</bdi> דקות | <bdi dir="ltr">Storage</bdi> ריק; <bdi dir="ltr">Private endpoint</bdi> בתשלום ואופציונלי |

השקופיות <bdi dir="ltr">23</bdi>–<bdi dir="ltr">25</bdi> מזכירות <bdi dir="ltr">VPN</bdi>, <bdi dir="ltr">ExpressRoute</bdi>, <bdi dir="ltr">Firewall</bdi> ו־<bdi dir="ltr">Network Watcher.</bdi> כאן אין פריסת <bdi dir="ltr">Gateway</bdi>, <bdi dir="ltr">Firewall</bdi> או <bdi dir="ltr">ExpressRoute:</bdi> עלות, זמן הקמה ותשתית <bdi dir="ltr">On-premises</bdi> הופכים אותם לתרחישי המשך, לא תנאי להדגמת <bdi dir="ltr">Peering.</bdi> תרשים ה־<bdi dir="ltr">Lab</bdi> משתמש ב־<bdi dir="ltr">CoreServicesVnet/ManufacturingVnet</bdi>; הדמו הקיים משתמש בשמות וטווחים אחרים, כמפורט בהדגמה <bdi dir="ltr">3.</bdi>

## הכנה וגבולות בטיחות

1. ב־[<bdi dir="ltr">Azure portal</bdi>](https://portal.azure.com) > **<bdi dir="ltr">Settings > Directories + subscriptions</bdi>** ודאו <bdi dir="ltr">Tenant</bdi> ומינוי מעבדה; בכל אשף אשרו את <bdi dir="ltr">Subscription</bdi> שוב. אין לחבר רשתות ארגוניות או לבצע <bdi dir="ltr">Cross-tenant peering.</bdi>
2. למסלול הראשי צרו <bdi dir="ltr">RG</bdi> חדש <bdi dir="ltr">`rg-az104-m05-demo`</bdi>, <bdi dir="ltr">Region</bdi> **<bdi dir="ltr">West Europe</bdi>**, <bdi dir="ltr">Tag</bdi> <bdi dir="ltr">`DemoOwner=AZ104-M05`</bdi>. אם קיים, בחרו שם חדש בכל הצעדים. אין למחוק <bdi dir="ltr">RG</bdi> קיים כדי לפנות שם.
3. נדרשת <bdi dir="ltr">Network Contributor</bdi> על <bdi dir="ltr">RG</bdi> של שני קצות <bdi dir="ltr">Peering</bdi>, <bdi dir="ltr">Contributor</bdi> ל־<bdi dir="ltr">Storage</bdi> ול־<bdi dir="ltr">Private endpoint</bdi>, והרשאה ל־<bdi dir="ltr">Private DNS zone</bdi> ול־<bdi dir="ltr">VNet link.</bdi> מנהל המעבדה יספק מראש הרשאות מינימליות; אין להוסיף <bdi dir="ltr">Owner</bdi> במינוי.
4. טווחי המסלול הראשי: <bdi dir="ltr">`vnet-m05-a = 10.50.0.0/16`</bdi>, <bdi dir="ltr">Subnet</bdi> <bdi dir="ltr">`snet-app = 10.50.1.0/24`</bdi>; <bdi dir="ltr">`vnet-m05-b = 10.51.0.0/16`</bdi>, <bdi dir="ltr">Subnet</bdi> <bdi dir="ltr">`snet-app = 10.51.1.0/24`</bdi>. בדקו שאין חפיפה עם רשתות שתחוברנה בפועל.
5. אין <bdi dir="ltr">VM</bdi>, <bdi dir="ltr">Public IP</bdi>, <bdi dir="ltr">NAT</bdi> או <bdi dir="ltr">Gateway</bdi> במסלול הראשי. <bdi dir="ltr">VNet</bdi>, <bdi dir="ltr">Peering</bdi> ו־<bdi dir="ltr">Route table</bdi> ללא תעבורה אינם מצריכים <bdi dir="ltr">Compute</bdi>; העברת נתונים ב־<bdi dir="ltr">Peering</bdi> מחויבת. <bdi dir="ltr">Storage/Private DNS/Private endpoint</bdi> יכולים להיות מחויבים גם במעבדה קצרה.
6. אין להריץ סקריפטים על מינוי <bdi dir="ltr">Production</bdi>, להזין סיסמאות לקבצים, להציג <bdi dir="ltr">Access keys</bdi> או לבדוק <bdi dir="ltr">Blob data</bdi> עם <bdi dir="ltr">Credentials</bdi> של ארגון.

## הדגמה <bdi dir="ltr">1</bdi> — <bdi dir="ltr">Peering</bdi> לשני כיוונים

**מטרה:** לבצע את הדגמת שקופית <bdi dir="ltr">10</bdi> ולראות <bdi dir="ltr">Connected</bdi> בשני הצדדים.

**דרישות:** <bdi dir="ltr">RG</bdi> חדש, הרשאות <bdi dir="ltr">Network</bdi> לשתי הרשתות. אין צורך ב־<bdi dir="ltr">VM</bdi> או <bdi dir="ltr">VPN gateway.</bdi>

### צעדים

1. **<bdi dir="ltr">Resource groups > Create</bdi>**: צרו <bdi dir="ltr">RG</bdi> לפי ההכנה.
2. **<bdi dir="ltr">Virtual networks > Create</bdi>**: צרו <bdi dir="ltr">`vnet-m05-a`</bdi>, <bdi dir="ltr">Region</bdi> **<bdi dir="ltr">West Europe</bdi>**, <bdi dir="ltr">RG</bdi> הדמו, <bdi dir="ltr">Address space</bdi> <bdi dir="ltr">`10.50.0.0/16`</bdi>, <bdi dir="ltr">Subnet</bdi> <bdi dir="ltr">`snet-app`</bdi> עם <bdi dir="ltr">`10.50.1.0/24`</bdi>.
3. צרו באותו אופן <bdi dir="ltr">`vnet-m05-b`</bdi>, <bdi dir="ltr">Address space</bdi> <bdi dir="ltr">`10.51.0.0/16`</bdi>, <bdi dir="ltr">Subnet</bdi> <bdi dir="ltr">`snet-app`</bdi> עם <bdi dir="ltr">`10.51.1.0/24`</bdi>. הסירו <bdi dir="ltr">Subnet</bdi> ברירת מחדל באשף אם היא חופפת. אין <bdi dir="ltr">Security services</bdi> בתשלום, <bdi dir="ltr">Delegation</bdi> או <bdi dir="ltr">Service endpoint</bdi> בשלב זה.
4. <span dir="ltr">**vnet-m05-a > Peerings > + Add**:</span>
   - <span dir="ltr">Local peering link name `a-to-b`.</span>
   - <bdi dir="ltr">Remote virtual network:</bdi> המינוי המאושר, <bdi dir="ltr">`vnet-m05-b`</bdi>.
   - <span dir="ltr">Remote peering link name `b-to-a`.</span>
   - **<bdi dir="ltr">Allow virtual network access / Allow the peered virtual network to access...</bdi>**: <bdi dir="ltr">Enabled</bdi> בשני הצדדים.
   - **<bdi dir="ltr">Allow forwarded traffic</bdi>**: <bdi dir="ltr">Disabled</bdi> בשני הצדדים; אין <bdi dir="ltr">NVA</bdi> בדמו זה.
   - **<bdi dir="ltr">Allow gateway transit / Use remote gateways / Gateway or route server traffic</bdi>**: <bdi dir="ltr">Disabled</bdi> בשני הצדדים.
5. שמות השדות עשויים להשתנות. ב־<bdi dir="ltr">Review</bdi> ודאו שייווצרו שני <bdi dir="ltr">Links</bdi> ורק <bdi dir="ltr">Access</bdi> רגיל. לחצו **<bdi dir="ltr">Add</bdi>**.
6. רעננו את **<bdi dir="ltr">Peerings</bdi>** ברשת <bdi dir="ltr">A</bdi> ואז ברשת <bdi dir="ltr">B. Status</bdi> מצופה **<bdi dir="ltr">Connected</bdi>** לשני <bdi dir="ltr">Links.</bdi> אם הפורטל יצר רק כיוון אחד בשל הרשאות, פתחו <bdi dir="ltr">B ></bdi> **<bdi dir="ltr">Peerings > Add</bdi>** וצרו את הכיוון החסר <bdi dir="ltr">`b-to-a`</bdi> אל <bdi dir="ltr">A</bdi>, עם אותן הגדרות — אין ליצור כפל <bdi dir="ltr">Link.</bdi>
7. הציגו את שתי הרשתות בטאב נפרד כדי להראות שאין <bdi dir="ltr">Gateway</bdi> ב־<bdi dir="ltr">Connected peering.</bdi> אין לבצע <bdi dir="ltr">Ping</bdi> מתוך <bdi dir="ltr">Cloud Shell:</bdi> הוא אינו בתוך אף אחת מהרשתות.

**תוצאה ואימות:** שני <bdi dir="ltr">Links Connected</bdi> ושתי כתובות רשת לא חופפות. זו הוכחה למצב <bdi dir="ltr">Control plane</bdi>; בלי <bdi dir="ltr">VM</bdi> אין בדיקת תעבורה.

**נקודת הוראה:** <bdi dir="ltr">Regional peering</bdi> הוא בין רשתות באותו <bdi dir="ltr">Region</bdi>; <bdi dir="ltr">Global</bdi> בין <bdi dir="ltr">Regions.</bdi> לא נדרש <bdi dir="ltr">Gateway</bdi> ל־<bdi dir="ltr">Peering</bdi> עצמו. “<bdi dir="ltr">Connected</bdi>” אינו אומר שיש <bdi dir="ltr">DNS</bdi>, <bdi dir="ltr">Port</bdi> פתוח או <bdi dir="ltr">Transit</bdi> לרשת שלישית.

**תקלות נפוצות:** <bdi dir="ltr">Initiated</bdi> — חסר הצד השני או הרשאה עליו; <bdi dir="ltr">Disconnected</bdi> — בדקו <bdi dir="ltr">Link</bdi> מרוחק. חפיפת <bdi dir="ltr">Address space</bdi> — לא משנים רשת קיימת, אלא מתקנים רק את רשתות הדמו. <bdi dir="ltr">Gateway sharing</bdi> דורש <bdi dir="ltr">Gateway</bdi> אמיתי ותנאים נוספים; לא מפעילים אותו באשף ריק.

**ניקוי:** להשאיר להדגמות <bdi dir="ltr">2</bdi> ו־<bdi dir="ltr">4.</bdi> לניקוי נפרד הסירו <bdi dir="ltr">`a-to-b`</bdi> ו־<bdi dir="ltr">`b-to-a`</bdi> בשני הצדדים, בלי להסיר <bdi dir="ltr">Peerings</bdi> שלא נוצרו בדמו.

## הדגמה <bdi dir="ltr">2</bdi> — <bdi dir="ltr">UDR</bdi> עם יעד <bdi dir="ltr">Drop</bdi>, ללא <bdi dir="ltr">NVA</bdi>

**מטרה:** לבצע את שלושת צעדי שקופית <bdi dir="ltr">16</bdi> — <bdi dir="ltr">Table</bdi>, <bdi dir="ltr">Route</bdi> ו־<bdi dir="ltr">Subnet association</bdi> — ולהמחיש שאפשר להגדיר <bdi dir="ltr">Route</bdi> בלי לשלוח תעבורה.

**דרישות:** הדגמה <bdi dir="ltr">1</bdi>, <bdi dir="ltr">Network Contributor</bdi> ב־<bdi dir="ltr">RG. Resource</bdi> נוסף: <bdi dir="ltr">`rt-m05-drop`</bdi>.

### צעדים

1. **<bdi dir="ltr">Route tables > Create</bdi>**: <bdi dir="ltr">RG</bdi> הדמו, <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`rt-m05-drop`</bdi>, <bdi dir="ltr">Region</bdi> **<bdi dir="ltr">West Europe</bdi>**. אם מוצג **<bdi dir="ltr">Propagate gateway routes</bdi>**, השאירו ברירת מחדל; אין <bdi dir="ltr">Gateway</bdi> או <bdi dir="ltr">BGP</bdi> במעבדה.
2. **<bdi dir="ltr">rt-m05-drop > Routes > Add</bdi>**: <bdi dir="ltr">Route name</bdi> <bdi dir="ltr">`drop-demo-testnet`</bdi>, <bdi dir="ltr">Destination type</bdi> **<bdi dir="ltr">IP Addresses</bdi>** אם מוצע, <bdi dir="ltr">Address prefix</bdi> <bdi dir="ltr">`192.0.2.0/24`</bdi>, <bdi dir="ltr">Next hop type</bdi> **<bdi dir="ltr">None</bdi>**. אין <bdi dir="ltr">Next hop IP</bdi> במצב <bdi dir="ltr">None.</bdi>
3. <span dir="ltr">**Subnets > Associate**: VNet `vnet-m05-a`, Subnet `snet-app`.</span>
4. פתחו **<bdi dir="ltr">vnet-m05-a > Subnets > snet-app</bdi>**: <bdi dir="ltr">Route table</bdi> חייב להיות <bdi dir="ltr">`rt-m05-drop`</bdi>.
5. פתחו **<bdi dir="ltr">Routes</bdi>** ובדקו <bdi dir="ltr">Prefix</bdi> ו־<bdi dir="ltr">Next hop.</bdi> אין לשלוח תעבורה ל־<bdi dir="ltr">TEST-NET</bdi> ואין לטעון שבדקתם <bdi dir="ltr">Drop</bdi> בפועל.
6. הציגו את שקופית <bdi dir="ltr">14: System routes</bdi> אינן משאבים בתוך <bdi dir="ltr">Route table</bdi> הזה. כאשר <bdi dir="ltr">NIC</bdi> של <bdi dir="ltr">VM</bdi> פעיל קיים, **<bdi dir="ltr">Effective routes</bdi>** מציגות <bdi dir="ltr">System</bdi>, <bdi dir="ltr">Peering</bdi> ו־<bdi dir="ltr">User routes</bdi>; אין <bdi dir="ltr">NIC</bdi> במסלול זה ולכן המסך אינו חלק מהאימות.
7. פתחו **<bdi dir="ltr">Subnet</bdi>** ושנו <bdi dir="ltr">Route table</bdi> ל־**<bdi dir="ltr">None</bdi>** > **<bdi dir="ltr">Save</bdi>**, לאחר מכן מחקו רק <bdi dir="ltr">`rt-m05-drop`</bdi>.

**תוצאה ואימות:** <bdi dir="ltr">Route</bdi> מופיע ומשויך ל־<bdi dir="ltr">Subnet</bdi> הנכון; לאחר <bdi dir="ltr">Reset</bdi> אין <bdi dir="ltr">Table association.</bdi> אין בדיקת <bdi dir="ltr">Traffic plane</bdi> במסלול ללא <bdi dir="ltr">VM.</bdi>

**נקודת הוראה:** <bdi dir="ltr">Azure</bdi> בוחרת קודם <bdi dir="ltr">Prefix</bdi> הארוך ביותר; כאשר <bdi dir="ltr">Prefix</bdi> זהה, <bdi dir="ltr">User route</bdi> בדרך כלל גוברת על <bdi dir="ltr">BGP</bdi> ועל <bdi dir="ltr">System route</bdi> בכפוף לחריגי השירות. לכן אין להסיק ש־<bdi dir="ltr">UDR</bdi> רחב תמיד עוקף <bdi dir="ltr">Route</bdi> ספציפי יותר. <bdi dir="ltr">Subnet</bdi> יכולה להיות משויכת ל־<bdi dir="ltr">Route table</bdi> אחת בלבד.

**תקלות נפוצות:** שיוך חסר — בדקו <bdi dir="ltr">Region</bdi> ו־<bdi dir="ltr">VNet. None</bdi> ב־<bdi dir="ltr">Next hop</bdi> אינו זהה ל־<bdi dir="ltr">None</bdi> בבחירת <bdi dir="ltr">Route table</bdi> של <bdi dir="ltr">Subnet. Virtual appliance</bdi> דורש <bdi dir="ltr">IP</bdi> של <bdi dir="ltr">NVA</bdi> נגיש ומתפקד, לא כתובת שרירותית.

**ניקוי:** <bdi dir="ltr">Table</bdi> והשיוך הוסרו. אין לשנות <bdi dir="ltr">System routes</bdi> או טבלאות משותפות; הרשתות נשארות להדגמה <bdi dir="ltr">4.</bdi>

## הדגמה <bdi dir="ltr">3</bdi> — הרחבה אופציונלית לדמו הקיים: <bdi dir="ltr">Hub</bdi>, <bdi dir="ltr">NVA</bdi> ו־<bdi dir="ltr">Transit</bdi>

**מטרה:** להראות ש־<bdi dir="ltr">Peering</bdi> אינו <bdi dir="ltr">Transitive</bdi> ולהעביר <bdi dir="ltr">Traffic</bdi> בין <bdi dir="ltr">Spokes</bdi> באמצעות שני <bdi dir="ltr">UDRs</bdi> ו־<bdi dir="ltr">IP forwarding.</bdi>

**דמו מקורי:** [<bdi dir="ltr">demo.md</bdi>](./demo.md). ההוראות הבאות מוסיפות הכנת מרצה בטוחה ואימות; הן אינן משנות את הסקריפט או התבנית בריפו.

### מה הקבצים הקיימים יוצרים בפועל

| רכיב | שם / הגדרה |
|---:|---:|
| <span dir="ltr">Script RG / Region</span> | <span dir="ltr">`rg-az104-routing-demo` / `westeurope`</span> |
| <span dir="ltr">Hub</span> | <span dir="ltr">`vnet-hub`, `10.0.0.0/16`, `snet-hub = 10.0.0.0/24`</span> |
| <span dir="ltr">Spoke 1</span> | <span dir="ltr">`vnet-1`, `10.1.0.0/16`, `subnet-1 = 10.1.0.0/24`</span> |
| <span dir="ltr">Spoke 2</span> | <span dir="ltr">`vnet-2`, `10.2.0.0/16`, `subnet-2 = 10.2.0.0/24`</span> |
| <span dir="ltr">VMs</span> | <span dir="ltr">`vm-nva = 10.0.0.4`, `vm-1 = 10.1.0.4`, `vm-2 = 10.2.0.4`</span> |
| <span dir="ltr">Compute</span> | שלוש <bdi dir="ltr">Ubuntu 22.04 LTS Gen2</bdi>, <bdi dir="ltr">Default</bdi> <bdi dir="ltr">`Standard_B1s`</bdi>, <bdi dir="ltr">Username</bdi> <bdi dir="ltr">`azureadmin`</bdi> |
| <span dir="ltr">Public IPs</span> | <span dir="ltr">`pip-vm-nva`, `pip-vm-1`, `pip-vm-2`, Standard Static</span> |
| <span dir="ltr">NSG</span> | <bdi dir="ltr">`nsg-az104-demo`</bdi>, <bdi dir="ltr">Internal allow</bdi> ל־<bdi dir="ltr">`10.0.0.0/8`</bdi>, <bdi dir="ltr">SSH inbound</bdi> מ־<bdi dir="ltr">`*`</bdi> |
| <span dir="ltr">Route tables</span> | <bdi dir="ltr">`rt-vnet1-to-vnet2`</bdi>, <bdi dir="ltr">`rt-vnet2-to-vnet1`</bdi>; נוצרות ללא <bdi dir="ltr">Subnet associations</bdi> |
| <span dir="ltr">NVA</span> | <bdi dir="ltr">NIC</bdi> עם <bdi dir="ltr">`enableIPForwarding=true`</bdi>; <bdi dir="ltr">Cloud-init</bdi> מפעיל <bdi dir="ltr">`net.ipv4.ip_forward=1`</bdi> |

<bdi dir="ltr">`main.bicep`</bdi> יוצר ארבעה <bdi dir="ltr">Hub/Spoke directional peerings</bdi> עם <bdi dir="ltr">Forwarded traffic</bdi> מותר, אך **אין** <bdi dir="ltr">Spoke-to-Spoke peering.</bdi> שני <bdi dir="ltr">UDRs</bdi> מצביעים ל־<bdi dir="ltr">`10.0.0.4`</bdi>. <bdi dir="ltr">`deploy.ps1`</bdi> שומר <bdi dir="ltr">Context</bdi> קיים אם נמצא, יוצר <bdi dir="ltr">RG</bdi> בשם קבוע, מבקש <bdi dir="ltr">`adminPassword`</bdi> כפרמטר <bdi dir="ltr">Secure</bdi> של התבנית, ואז שולח <bdi dir="ltr">Stop/deallocate</bdi> לכל שלוש <bdi dir="ltr">VMs</bdi> עם <bdi dir="ltr">`-NoWait`</bdi>. הוא אינו ממתין לסיום <bdi dir="ltr">Stop</bdi> ואינו בודק בעלות על <bdi dir="ltr">RG.</bdi>

### דרישות ושער בטיחות לפני פריסה עתידית

- מינוי מעבדה מבודד, <bdi dir="ltr">Contributor</bdi> למשאבי הדמו, <bdi dir="ltr">Compute quota</bdi> לשלוש <bdi dir="ltr">VMs</bdi> ול־<bdi dir="ltr">Public IPs</bdi>, <bdi dir="ltr">Az</bdi> ו־<bdi dir="ltr">Bicep CLI</bdi> במסוף <bdi dir="ltr">Windows</bdi>, <bdi dir="ltr">SSH client</bdi> וכתובת <bdi dir="ltr">IPv4</bdi> ציבורית של המרצה.
- משאבי <bdi dir="ltr">Compute</bdi>, <bdi dir="ltr">Disks</bdi> ו־<bdi dir="ltr">Public IPs</bdi> עולים כסף. הכינו מראש; אין להבטיח ש־<bdi dir="ltr">Standard_B1s</bdi> זמין בכל מינוי. אם אין תקציב או <bdi dir="ltr">Quota</bdi>, בצעו רק הדגמות <bdi dir="ltr">1</bdi>–<bdi dir="ltr">2</bdi> והציגו את הקבצים המקוריים בקריאה בלבד.
- **המקור מאפשר <bdi dir="ltr">SSH</bdi> מכל כתובת. אין להריץ אותו כמות שהוא על סביבת <bdi dir="ltr">Production</bdi> או לחשוף <bdi dir="ltr">VMs</bdi> לציבור בזמן שמחכים לשנות <bdi dir="ltr">NSG.</bdi>** למסלול ביצוע בטוח הכינו עותק מעבדה נפרד כמפורט להלן, או השתמשו במעבדה מוכנה שבה <bdi dir="ltr">SSH</bdi> כבר מוגבל. אין לסמוך על תיקון לאחר הפריסה בלבד.
- הקבצים המקוריים אינם מקבלים <bdi dir="ltr">Switches</bdi> כמו <bdi dir="ltr">`-ResourceGroupName`</bdi> או <bdi dir="ltr">`-Location`</bdi>. ל־<bdi dir="ltr">`main.bicep`</bdi> יש <bdi dir="ltr">Parameters</bdi> <bdi dir="ltr">`location`</bdi>, <bdi dir="ltr">`adminUsername`</bdi>, <bdi dir="ltr">`adminPassword`</bdi>, <bdi dir="ltr">`vmSize`</bdi>; <bdi dir="ltr">`deploy.ps1`</bdi> אינו חושף אותם כ־<bdi dir="ltr">Script parameters.</bdi>

### הכנת המרצה — עותק בלבד, לא עריכת הריפו

1. במסוף <bdi dir="ltr">Windows</bdi> מקומי פתחו את תיקיית מודול <bdi dir="ltr">05.</bdi> צרו תיקייה חדשה <bdi dir="ltr">`classroom-m05-copy`</bdi> והעתיקו אליה את **שני** הקבצים בלבד:

   <div dir="ltr" align="right">

   ```powershell
   Set-Location "C:\Repo\AZ-104\slides\Module 05 - Administer Intersite Connectivity"
   New-Item -ItemType Directory -Path .\classroom-m05-copy
   Copy-Item .\deploy.ps1, .\main.bicep -Destination .\classroom-m05-copy
   Set-Location .\classroom-m05-copy
   ```

   </div>


   אם התיקייה כבר קיימת, בחרו תיקייה חדשה; אין לדרוס עותק של משתתף. אין לשמור סיסמה בקבצים ואין לבצע <bdi dir="ltr">Commit</bdi> לעותק ההדגמה.

2. פתחו **רק את <bdi dir="ltr">main.bicep</bdi> שבעותק** בעורך. בתוך הכלל ששמו <bdi dir="ltr">`Allow-SSH-Inbound`</bdi> שנו רק <bdi dir="ltr">`sourceAddressPrefix: '*'`</bdi> ל־<bdi dir="ltr">IPv4</bdi> הציבורי המאושר של המרצה עם <bdi dir="ltr">`/32`</bdi>. השאירו <bdi dir="ltr">Destination</bdi>, <bdi dir="ltr">Port</bdi> ו־<bdi dir="ltr">Rule priority</bdi> כפי שהם. אין לשנות את הכלל <bdi dir="ltr">Internal.</bdi>
3. בדקו שהכלל מאפשר רק את המקור המיועד, שאין <bdi dir="ltr">Secrets</bdi> בקובץ, ושהמקור בריפו לא השתנה. בדיקת קומפילציה מקומית:

   <div dir="ltr" align="right">

   ```powershell
   bicep build .\main.bicep --stdout
   ```

   </div>


4. התחברו ואשרו <bdi dir="ltr">Context</bdi> **לפני** <bdi dir="ltr">Script</bdi>, כי הוא משתמש בהקשר פעיל:

   <div dir="ltr" align="right">

   ```powershell
   Connect-AzAccount
   Set-AzContext -Tenant "<LAB-TENANT-ID>" -SubscriptionId "<LAB-SUBSCRIPTION-ID>"
   Get-AzContext | Select-Object Tenant, Subscription
   if (Get-AzResourceGroup -Name "rg-az104-routing-demo" -ErrorAction SilentlyContinue) {
       throw "Existing RG: do not deploy until a dedicated fresh lab is provided."
   }
   ```

   </div>


5. רק במעבדה שאושרה, הריצו את העותק:

   <div dir="ltr" align="right">

   ```powershell
   .\deploy.ps1
   ```

   </div>


   הזינו סיסמת <bdi dir="ltr">VM</bdi> חזקה בפרומפט <bdi dir="ltr">Secure</bdi> בלבד. אל תקלידו אותה בפקודה, ב־<bdi dir="ltr">Transcript</bdi> או במסמך. אם <bdi dir="ltr">Deployment</bdi> נכשל, אל תמשיכו לשלבי התעבורה; בדקו רק <bdi dir="ltr">Resources</bdi> שנוצרו חלקית ב־<bdi dir="ltr">RG</bdi> הדמו.
6. בפורטל **<bdi dir="ltr">RG > Deployments</bdi>** ודאו <bdi dir="ltr">Succeeded.</bdi> המתינו שכל שלוש <bdi dir="ltr">VMs</bdi> מציגות **<bdi dir="ltr">Stopped</bdi> (<bdi dir="ltr">deallocated</bdi>)**. התחילו את כולן בפורטל והמתינו ל־**<bdi dir="ltr">Running</bdi>**. <bdi dir="ltr">Stop commands</bdi> אסינכרוניים יכולים עדיין להסתיים אחרי תחילת <bdi dir="ltr">Start</bdi> מוקדמת.
7. **<bdi dir="ltr">NSG > Inbound security rules > Allow-SSH-Inbound</bdi>**: אמתו שה־<bdi dir="ltr">Source</bdi> הוא <bdi dir="ltr">`/32`</bdi> שהגדרתם בעותק. אם אינו כך, עצרו ותקנו לפני גישת <bdi dir="ltr">SSH</bdi>; אין להמשיך עם <bdi dir="ltr">Any.</bdi>

### הדגמה חיה — <bdi dir="ltr">Peering</bdi> ללא <bdi dir="ltr">Transit</bdi>, ואז <bdi dir="ltr">UDR</bdi> בשני הכיוונים

1. ב־<bdi dir="ltr">Overview</bdi> של כל <bdi dir="ltr">VM</bdi> העתיקו <bdi dir="ltr">Public IP</bdi> שלו. פתחו שלושה מסופים מקומיים:

   <div dir="ltr" align="right">

   ```powershell
   ssh azureadmin@<PUBLIC-IP-OF-VM-NVA>
   ssh azureadmin@<PUBLIC-IP-OF-VM-1>
   ssh azureadmin@<PUBLIC-IP-OF-VM-2>
   ```

   </div>


   כל פקודה בחלון נפרד; כתובות אלה מתקבלות מהפורטל, אין לנחש. אם נדרשת אימות <bdi dir="ltr">Host key</bdi>, השוו לערך המאומת שסופק בהכנת המעבדה; אין להשתמש ב־<bdi dir="ltr">StrictHostKeyChecking</bdi>=<bdi dir="ltr">no.</bdi>

2. **בתוך <bdi dir="ltr">NVA</bdi>**:

   <div dir="ltr" align="right">

   ```bash
   sudo cloud-init status --wait
   sysctl net.ipv4.ip_forward
   ```

   </div>


   מצופה <bdi dir="ltr">Cloud-init</bdi> שהושלם ו־<bdi dir="ltr">`net.ipv4.ip_forward = 1`</bdi>. אם לא, בדקו <bdi dir="ltr">Cloud-init</bdi> לפני בדיקות ניתוב.

3. בפורטל ודאו <bdi dir="ltr">Connected</bdi> בכל ארבעת <bdi dir="ltr">Hub/Spoke peerings</bdi> ו־<bdi dir="ltr">Forwarded traffic</bdi> מותר, וכן **<bdi dir="ltr">NIC nic-vm-nva > IP configurations</bdi>** עם <bdi dir="ltr">IP forwarding Enabled.</bdi> אין <bdi dir="ltr">Peering</bdi> ישיר בין <bdi dir="ltr">Spokes.</bdi>
4. **בתוך <bdi dir="ltr">VM1</bdi>**:

   <div dir="ltr" align="right">

   ```bash
   ping -c 4 -W 2 10.0.0.4
   ping -c 4 -W 2 10.2.0.4
   ```

   </div>


   <bdi dir="ltr">NVA</bdi> אמור להשיב; <bdi dir="ltr">VM2</bdi> לא אמור להשיב לפני שיוך <bdi dir="ltr">UDR.</bdi> אם גם <bdi dir="ltr">NVA</bdi> לא עונה, זו תקלה בסיסית ולא הוכחה ל־<bdi dir="ltr">Non-transitivity.</bdi>
5. **<bdi dir="ltr">Route tables > Routes</bdi>** בדקו את הטבלאות הקיימות, ואז **<bdi dir="ltr">Subnets > Associate</bdi>**:

   | <span dir="ltr">Table</span> | <span dir="ltr">Destination</span> | <span dir="ltr">Next hop</span> | <span dir="ltr">Subnet</span> |
   |---:|---:|---:|---:|
   | <span dir="ltr">`rt-vnet1-to-vnet2`</span> | <span dir="ltr">`10.2.0.0/16`</span> | <span dir="ltr">Virtual appliance `10.0.0.4`</span> | <span dir="ltr">`vnet-1 / subnet-1`</span> |
   | <span dir="ltr">`rt-vnet2-to-vnet1`</span> | <span dir="ltr">`10.1.0.0/16`</span> | <span dir="ltr">Virtual appliance `10.0.0.4`</span> | <span dir="ltr">`vnet-2 / subnet-2`</span> |

   אל תשייכו <bdi dir="ltr">Table</bdi> ל־<bdi dir="ltr">Hub</bdi>; דרושים שני השיוכים לתעבורה ולנתיב החזרה.
6. לאחר <bdi dir="ltr">propagation</bdi>, ב־<bdi dir="ltr">VM1</bdi> הריצו שוב <bdi dir="ltr">Ping</bdi> ל־<bdi dir="ltr">`10.2.0.4`</bdi>, וב־<bdi dir="ltr">VM2:</bdi>

   <div dir="ltr" align="right">

   ```bash
   ping -c 4 -W 2 10.1.0.4
   ```

   </div>


   מצופים <bdi dir="ltr">Replies</bdi> בשני הכיוונים.
7. ב־**<bdi dir="ltr">nic-vm-1 > Effective routes</bdi>** ודאו <bdi dir="ltr">Route</bdi> ל־<bdi dir="ltr">`10.2.0.0/16`</bdi>, <bdi dir="ltr">Source</bdi> מסוג <bdi dir="ltr">User</bdi>, <bdi dir="ltr">Next hop</bdi> <bdi dir="ltr">`10.0.0.4`</bdi>; ב־<bdi dir="ltr">NIC</bdi> השני ודאו <bdi dir="ltr">Route</bdi> חזרה. <bdi dir="ltr">VMs</bdi> חייבות להיות פעילות.
8. אופציונלי: בתוך <bdi dir="ltr">NVA</bdi>, אם <bdi dir="ltr">`tcpdump`</bdi> כבר מותקן:

   <div dir="ltr" align="right">

   ```bash
   sudo tcpdump -ni any 'icmp and host 10.1.0.4 and host 10.2.0.4'
   ```

   </div>


   במקביל חזרו על <bdi dir="ltr">Ping</bdi> מ־<bdi dir="ltr">VM1</bdi>, צפו ב־<bdi dir="ltr">Requests/Replies</bdi> ועצרו **<bdi dir="ltr">Ctrl+C</bdi>**. אין צורך לשמור <bdi dir="ltr">Capture.</bdi> אם הכלי חסר, אפשר לדלג; התקנתו דורשת יציאה למאגרי חבילות ואישור המעבדה.
9. <bdi dir="ltr">Reset:</bdi> הסירו את שני <bdi dir="ltr">Subnet associations</bdi> בלבד. לאחר <bdi dir="ltr">propagation Ping</bdi> בין <bdi dir="ltr">Spokes</bdi> אמור להיכשל שוב; <bdi dir="ltr">Ping</bdi> ל־<bdi dir="ltr">NVA</bdi> אמור להמשיך לעבוד.

**תוצאה ואימות:** מעבר מכשל בין <bdi dir="ltr">Spokes</bdi> להצלחה בשני הכיוונים, <bdi dir="ltr">Effective routes</bdi> מתאימות, ואופציונלית <bdi dir="ltr">Capture</bdi> ב־<bdi dir="ltr">NVA. ICMP success</bdi> אינו בדיקת <bdi dir="ltr">Application</bdi> או אבטחת <bdi dir="ltr">Production.</bdi>

**נקודת הוראה:** <bdi dir="ltr">Forwarded traffic</bdi> ב־<bdi dir="ltr">Peering</bdi> אינו מייצר <bdi dir="ltr">Route</bdi> בעצמו. <bdi dir="ltr">NVA</bdi> צריכה <bdi dir="ltr">IP forwarding</bdi> גם ב־<bdi dir="ltr">Azure NIC</bdi> וגם ב־<bdi dir="ltr">Guest OS.</bdi> התבנית אינה <bdi dir="ltr">Firewall</bdi> מלא ואינה דוגמת <bdi dir="ltr">Production.</bdi>

**תקלות נפוצות:** <bdi dir="ltr">SSH Timeout</bdi> — בדקו <bdi dir="ltr">Public IP</bdi>, מקור <bdi dir="ltr">`/32`</bdi>, מצב <bdi dir="ltr">Running</bdi> וחסימת רשת הכיתה; אין לפתוח <bdi dir="ltr">Any. Ping</bdi> חד־כיווני — בדקו <bdi dir="ltr">UDR</bdi> חזרה ו־<bdi dir="ltr">NSG.</bdi> כשל לאחר <bdi dir="ltr">Stop/Start</bdi> — בדקו <bdi dir="ltr">Cloud-init</bdi> ו־<bdi dir="ltr">sysctl. Redeployment</bdi> עשוי להסיר שיוכי <bdi dir="ltr">UDR</bdi> ידניים; הרצת המקור גם תחזיר <bdi dir="ltr">SSH Any</bdi>, לכן אין לבצע <bdi dir="ltr">Redeploy</bdi> לא מבוקר.

**ניקוי:** סגרו <bdi dir="ltr">SSH</bdi> ו־<bdi dir="ltr">Capture.</bdi> ודאו <bdi dir="ltr">Context</bdi> ושאין משאבים שאינם של הדמו ב־<bdi dir="ltr">`rg-az104-routing-demo`</bdi>, ואז:

<div dir="ltr" align="right">

```powershell
Get-AzContext | Select-Object Tenant, Subscription
Remove-AzResourceGroup -Name "rg-az104-routing-demo"
```

</div>


אשרו רק לאחר בדיקה. אם שומרים זמנית את המעבדה, עצרו את שלוש <bdi dir="ltr">VMs</bdi> וודאו <bdi dir="ltr">Stopped</bdi> (<bdi dir="ltr">deallocated</bdi>), אך <bdi dir="ltr">Disks/Public IPs</bdi> עדיין מחויבים. מחקו את תיקיית העותק רק אם יצרתם אותה ושום משתתף אינו משתמש בה; הקבצים המקוריים נשארים ללא שינוי.

## הדגמה <bdi dir="ltr">4</bdi> — <bdi dir="ltr">Endpoints</bdi> ב־<bdi dir="ltr">Portal</bdi>, ללא נתוני משתמש

**מטרה:** להבחין בין <bdi dir="ltr">Service endpoint</bdi> שמאפשר <bdi dir="ltr">Network rule</bdi> ל־<bdi dir="ltr">Subnet</bdi> לבין <bdi dir="ltr">Private endpoint</bdi> בעל כתובת פרטית ו־<bdi dir="ltr">DNS</bdi> פרטי.

**דרישות:** רשת <bdi dir="ltr">A</bdi> מהדגמה <bdi dir="ltr">1</bdi>; <bdi dir="ltr">Contributor</bdi> ל־<bdi dir="ltr">Storage</bdi> ול־<bdi dir="ltr">Private endpoint</bdi>, <bdi dir="ltr">Private DNS</bdi> הרשאות, <bdi dir="ltr">Storage provider</bdi> רשום מראש. שם <bdi dir="ltr">Storage</bdi> לדוגמה <bdi dir="ltr">`az104m05ep261122a`</bdi>; הוא גלובלי, ולכן אם תפוס בחרו סיומת אותיות/ספרות אחרת באורך כולל <bdi dir="ltr">3</bdi>–<bdi dir="ltr">24</bdi> תווים ורשמו אותה לכל השלבים. אין <bdi dir="ltr">Access keys</bdi> או <bdi dir="ltr">Data plane role assignment</bdi> בדמו זה.

### חלק א — <bdi dir="ltr">Service endpoint</bdi> ותלות ב־<bdi dir="ltr">Storage firewall</bdi>

1. **<bdi dir="ltr">Storage accounts > Create</bdi>**: <bdi dir="ltr">RG</bdi> <bdi dir="ltr">`rg-az104-m05-demo`</bdi>, <bdi dir="ltr">Region</bdi> **<bdi dir="ltr">West Europe</bdi>**, <bdi dir="ltr">Name</bdi> הייחודי שבחרתם, <bdi dir="ltr">Performance</bdi> **<bdi dir="ltr">Standard</bdi>**, <bdi dir="ltr">Redundancy</bdi> **<bdi dir="ltr">LRS</bdi>**, <bdi dir="ltr">Account kind</bdi> **<bdi dir="ltr">StorageV2</bdi>** אם מוצג. אין <bdi dir="ltr">Hierarchical namespace</bdi>, <bdi dir="ltr">SFTP</bdi> או <bdi dir="ltr">NFS.</bdi> השאירו <bdi dir="ltr">Secure transfer</bdi> ו־<bdi dir="ltr">TLS 1.2</bdi>; אל תאפשרו <bdi dir="ltr">Anonymous blob access.</bdi>
2. ב־**<bdi dir="ltr">Networking</bdi>** בחרו <bdi dir="ltr">Public network access</bdi> **<bdi dir="ltr">Enabled from selected virtual networks and IP addresses</bdi>** כאשר זמין. הוסיפו <bdi dir="ltr">VNet</bdi> <bdi dir="ltr">`vnet-m05-a`</bdi>, <bdi dir="ltr">Subnet</bdi> <bdi dir="ltr">`snet-app`</bdi>. אם האשף אינו מאפשר הגדרה זו, צרו עם <bdi dir="ltr">Public network access</bdi> **<bdi dir="ltr">Disabled</bdi>**, ואז עברו ל־<bdi dir="ltr">Networking</bdi> והפעילו רק <bdi dir="ltr">Selected networks</bdi> לצורך הדמו.
3. אם האשף מציע <bdi dir="ltr">Enable service endpoint</bdi> ל־<bdi dir="ltr">Subnet</bdi>, אשרו **<bdi dir="ltr">Microsoft.Storage</bdi>** בלבד. לחלופין: **<bdi dir="ltr">VNet A > Subnets > snet-app > Service endpoints</bdi>**, בחרו **<bdi dir="ltr">Microsoft.Storage</bdi>** ושמרו, ואז חזרו ל־**<bdi dir="ltr">Storage > Networking > Virtual networks > Add existing virtual network</bdi>** והוסיפו אותה <bdi dir="ltr">Subnet.</bdi>
4. **<bdi dir="ltr">Storage > Networking</bdi>**: ודאו <bdi dir="ltr">Public access</bdi> מוגבל ל־<bdi dir="ltr">Selected networks</bdi>, ורק <bdi dir="ltr">VNet A / snet-app</bdi> נרשמה. אל תוסיפו <bdi dir="ltr">Client IP</bdi>, <bdi dir="ltr">Trusted services exceptions</bdi> או רשת <bdi dir="ltr">B</bdi> כדי לגרום לפורטל להציג נתונים.
5. **<bdi dir="ltr">VNet > Subnets</bdi>**: ודאו <bdi dir="ltr">Service endpoint Microsoft.Storage.</bdi> **<bdi dir="ltr">Storage > Endpoints</bdi>**: <bdi dir="ltr">Blob endpoint</bdi> עדיין בשם <bdi dir="ltr">`<account>.blob.core.windows.net`</bdi>; אין <bdi dir="ltr">NIC</bdi> או כתובת פרטית לחשבון בגלל <bdi dir="ltr">Service endpoint.</bdi>
6. אין ליצור <bdi dir="ltr">Container</bdi> או לבדוק <bdi dir="ltr">Blob</bdi> מתוך <bdi dir="ltr">Cloud Shell</bdi> רגיל; הוא אינו ברשת <bdi dir="ltr">A</bdi> וה־<bdi dir="ltr">Firewall</bdi> יכול לחסום אותו. המסלול מוכיח תצורה בלבד, לא גישה לנתונים.

**תוצאה ואימות:** <bdi dir="ltr">Service endpoint</bdi> קיים ב־<bdi dir="ltr">Subnet</bdi> ו־<bdi dir="ltr">Virtual network rule</bdi> קיימת בחשבון. <bdi dir="ltr">Endpoint</bdi> של השירות עדיין <bdi dir="ltr">Public</bdi> מבחינת כתובת/<bdi dir="ltr">DNS</bdi>, אך <bdi dir="ltr">Firewall</bdi> מצמצם מי יכול לגשת אליו.

**נקודת הוראה:** <bdi dir="ltr">Enable service endpoint</bdi> לבדו אינו מגביל <bdi dir="ltr">Storage</bdi>; נדרש גם כלל בצד <bdi dir="ltr">Storage.</bdi> בקרת <bdi dir="ltr">Network</bdi> אינה מעניקה הרשאת <bdi dir="ltr">Data plane.</bdi>

**תקלות נפוצות:** ה־<bdi dir="ltr">Subnet</bdi> לא ניתנת לבחירה — בדקו <bdi dir="ltr">Microsoft.Storage endpoint</bdi> והרשאות בשני המשאבים. <bdi dir="ltr">Portal data browser</bdi> חסום — צפוי כאשר <bdi dir="ltr">Client</bdi> אינו ברשת המותרת; אין לפתוח <bdi dir="ltr">All networks.</bdi>

**ניקוי חלק א:** אם לא מבצעים חלק ב, מחקו רק <bdi dir="ltr">Storage</bdi> הדמו, והסירו <bdi dir="ltr">Microsoft.Storage Service endpoint</bdi> מ־<bdi dir="ltr">Subnet</bdi> הדמו אם אינו נדרש. אין למחוק <bdi dir="ltr">VNet</bdi> עד סיום כל ההדגמות.

### חלק ב — <bdi dir="ltr">Private endpoint</bdi>, אופציונלי ובתשלום

**דרישות נוספות:** אישור עלות <bdi dir="ltr">Private endpoint</bdi> ו־<bdi dir="ltr">Private DNS zone</bdi>; הרשאת אישור <bdi dir="ltr">Connection</bdi> למשאב <bdi dir="ltr">Storage.</bdi> אין צורך ב־<bdi dir="ltr">VM</bdi> לתצוגת <bdi dir="ltr">Control plane.</bdi> כדי להוכיח <bdi dir="ltr">DNS/Traffic</bdi> מתוך <bdi dir="ltr">Client</bdi> נדרשת מעבדה עם <bdi dir="ltr">Client</bdi> ברשת ו־<bdi dir="ltr">Data plane role</bdi>; זה מחוץ למסלול זה ולא ייטען כאילו בוצע.

1. בחשבון <bdi dir="ltr">Storage</bdi> הדמו פתחו **<bdi dir="ltr">Networking > Private endpoint connections > + Private endpoint</bdi>**.
2. **<bdi dir="ltr">Basics</bdi>**: <bdi dir="ltr">RG</bdi> הדמו, <bdi dir="ltr">Name</bdi> <bdi dir="ltr">`pe-m05-blob`</bdi>, <bdi dir="ltr">Network interface name</bdi> <bdi dir="ltr">`nic-pe-m05-blob`</bdi> אם השדה מוצג, <bdi dir="ltr">Region</bdi> **<bdi dir="ltr">West Europe</bdi>**.
3. **<bdi dir="ltr">Resource</bdi>**: <bdi dir="ltr">Subscription</bdi> מאושר, <bdi dir="ltr">Resource type</bdi> **<bdi dir="ltr">Microsoft.Storage/storageAccounts</bdi>**, <bdi dir="ltr">Resource</bdi> חשבון הדמו, <bdi dir="ltr">Target sub-resource</bdi> **<bdi dir="ltr">blob</bdi>**. אין צורך ב־<bdi dir="ltr">Private Link Service</bdi> עצמאי לצריכת <bdi dir="ltr">Storage.</bdi>
4. **<bdi dir="ltr">Virtual network</bdi>**: <bdi dir="ltr">`vnet-m05-a`</bdi>, <bdi dir="ltr">Subnet</bdi> <bdi dir="ltr">`snet-app`</bdi>, <bdi dir="ltr">Dynamic private IP allocation.</bdi> השאירו <bdi dir="ltr">Application security group</bdi> ריק ואל תשנו <bdi dir="ltr">Network policies</bdi> כלליות למטרות נוספות.
5. **<bdi dir="ltr">DNS</bdi>**: <bdi dir="ltr">Integrate with private DNS zone</bdi> **<bdi dir="ltr">Yes</bdi>**. בחרו <bdi dir="ltr">Zone</bdi> חדשה <bdi dir="ltr">`privatelink.blob.core.windows.net`</bdi> ב־<bdi dir="ltr">RG</bdi> הדמו. אם קיימת <bdi dir="ltr">Zone</bdi> בשם זה, לא משתמשים ב־<bdi dir="ltr">Zone</bdi> משותפת ולא מוחקים אותה; מנהל המעבדה יספק <bdi dir="ltr">RG/Zone</bdi> ייעודיים או שתציגו את האשף בלי <bdi dir="ltr">Create.</bdi>
6. **<bdi dir="ltr">Review + create > Create</bdi>**. ב־**<bdi dir="ltr">Storage > Private endpoint connections</bdi>** בדקו <bdi dir="ltr">Connection state</bdi> **<bdi dir="ltr">Approved</bdi>**. אם <bdi dir="ltr">Pending</bdi>, רק בעל המשאב המורשה רשאי לאשר את חיבור הדמו; אין לעקוף תהליך אישור.
7. פתחו **<bdi dir="ltr">Private endpoint > Network interface</bdi>** ובדקו <bdi dir="ltr">Private IP</bdi> מתוך <bdi dir="ltr">`10.50.1.0/24`</bdi>. אין לנחש <bdi dir="ltr">`.4`</bdi>; <bdi dir="ltr">Azure</bdi> הקצתה כתובת בהתאם לזמינות.
8. ב־**<bdi dir="ltr">Private DNS zone > Recordsets</bdi>** בדקו רשומת <bdi dir="ltr">A</bdi> בשם חשבון הדמו עם אותה כתובת. ב־**<bdi dir="ltr">Virtual network links</bdi>** ודאו <bdi dir="ltr">Link</bdi> אל <bdi dir="ltr">`vnet-m05-a`</bdi>; אם לא נוצר, הוסיפו <bdi dir="ltr">`link-m05-a`</bdi> עם <bdi dir="ltr">Auto-registration</bdi> **<bdi dir="ltr">Disabled</bdi>**. אין צורך ברישום <bdi dir="ltr">VM</bdi> אוטומטי.
9. ב־**<bdi dir="ltr">Storage > Networking</bdi>** שנו <bdi dir="ltr">Public network access</bdi> ל־**<bdi dir="ltr">Disabled</bdi>** רק עבור חשבון הדמו. <bdi dir="ltr">Private endpoint</bdi> לא מכבה <bdi dir="ltr">Public access</bdi> בעצמו. <bdi dir="ltr">Management plane</bdi> של הפורטל עדיין מאפשר ניהול משאב; זה לא מוכיח <bdi dir="ltr">Data access.</bdi>
10. הסבירו באמצעות הרשומה: <bdi dir="ltr">Client</bdi> ברשת מקושרת עם <bdi dir="ltr">Azure DNS</bdi> יפנה לשם הרגיל <bdi dir="ltr">`<account>.blob.core.windows.net`</bdi>, שימופה לכתובת <bdi dir="ltr">Private endpoint</bdi> באמצעות <bdi dir="ltr">DNS</bdi> מתאים. **אין להריץ <bdi dir="ltr">nslookup</bdi> מתוך <bdi dir="ltr">Cloud Shell</bdi> רגיל ולטעון שזו הוכחת <bdi dir="ltr">Private DNS</bdi> ברשת <bdi dir="ltr">A.</bdi>**

**תוצאה ואימות:** <bdi dir="ltr">Connection Approved</bdi>, <bdi dir="ltr">NIC</bdi> בעל <bdi dir="ltr">Private IP</bdi>, רשומת <bdi dir="ltr">DNS</bdi> ו־<bdi dir="ltr">VNet link</bdi> תואמים, <bdi dir="ltr">Public network access Disabled.</bdi> לא נבדקו <bdi dir="ltr">Blob upload/download</bdi> או <bdi dir="ltr">DNS</bdi> מתוך <bdi dir="ltr">Guest.</bdi>

**נקודת הוראה:** <bdi dir="ltr">Private endpoint</bdi> מכסה <bdi dir="ltr">sub-resource</bdi> נבחר; <bdi dir="ltr">`blob`</bdi> אינו אוטומטית <bdi dir="ltr">`file`</bdi>, <bdi dir="ltr">`queue`</bdi> או <bdi dir="ltr">`dfs`</bdi>. עדיין נדרשים <bdi dir="ltr">Authentication</bdi> ו־<bdi dir="ltr">Authorization. Private endpoint</bdi> אינו כשלעצמו הגנה מלאה מפני <bdi dir="ltr">Data exfiltration.</bdi>

**תקלות נפוצות:** <bdi dir="ltr">Pending approval</bdi> — בדקו הרשאת בעל <bdi dir="ltr">Storage</bdi>, בלי הענקת <bdi dir="ltr">Owner</bdi> במינוי. <bdi dir="ltr">DNS zone</bdi> לא מכילה <bdi dir="ltr">A record</bdi> — בדקו <bdi dir="ltr">Private DNS zone group</bdi> ו־<bdi dir="ltr">Target blob. Zone</bdi> קיימת ב־<bdi dir="ltr">RG</bdi> משותף — אל תשנו אותה. <bdi dir="ltr">Public access Disabled</bdi> אינו מבטל חיבור <bdi dir="ltr">Private endpoint</bdi> מאושר.

**ניקוי חלק ב והמודול:** מחקו <bdi dir="ltr">`pe-m05-blob`</bdi>; ודאו שה־<bdi dir="ltr">NIC</bdi> המנוהל שלו הוסר, בלי למחוק <bdi dir="ltr">NIC</bdi> ידנית לפני <bdi dir="ltr">Endpoint.</bdi> מחקו רק <bdi dir="ltr">Zone</bdi> ו־<bdi dir="ltr">Link</bdi> שנוצרו לדמו, ואז <bdi dir="ltr">Storage.</bdi> הסירו <bdi dir="ltr">Service endpoint</bdi> מה־<bdi dir="ltr">Subnet</bdi> אם שומרים רשתות. לבסוף בדקו <bdi dir="ltr">Tenant</bdi> ומינוי ורשימת משאבי <bdi dir="ltr">`rg-az104-m05-demo`</bdi>, ואז **<bdi dir="ltr">Delete resource group</bdi>** רק אם כל המשאבים בו שלכם. <bdi dir="ltr">RG</bdi> של הדמו הקיים, <bdi dir="ltr">`rg-az104-routing-demo`</bdi>, מנוקה בנפרד לפי הדגמה <bdi dir="ltr">3.</bdi>

## מקורות <bdi dir="ltr">Microsoft</bdi>

- [ניהול <bdi dir="ltr">VNet peering</bdi> בפורטל](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering)
- [<bdi dir="ltr">Peering</bdi>, <bdi dir="ltr">Non-transitivity</bdi> ו־<bdi dir="ltr">Service chaining</bdi>](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview)
- [<bdi dir="ltr">System routes</bdi>, <bdi dir="ltr">UDR</bdi> ובחירת נתיב](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview)
- [ניהול <bdi dir="ltr">Route tables</bdi>](https://learn.microsoft.com/en-us/azure/virtual-network/manage-route-table)
- [<bdi dir="ltr">IP forwarding</bdi> ב־<bdi dir="ltr">NIC</bdi>](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-network-interface#enable-or-disable-ip-forwarding)
- <span dir="ltr">[Service endpoints](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview)</span>
- <span dir="ltr">[Storage network rules](https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security)</span>
- [<bdi dir="ltr">Storage Private endpoints</bdi>, <bdi dir="ltr">DNS</bdi> ו־<bdi dir="ltr">Public access</bdi>](https://learn.microsoft.com/en-us/azure/storage/common/storage-private-endpoints)
- [יצירת <bdi dir="ltr">Private endpoint</bdi> בפורטל](https://learn.microsoft.com/en-us/azure/private-link/create-private-endpoint-portal)

</div>
