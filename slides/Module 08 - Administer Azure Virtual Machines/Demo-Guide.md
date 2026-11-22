<div dir="rtl" align="right">

# מודול <bdi dir="ltr">08</bdi> — הדגמות <bdi dir="ltr">Azure Virtual Machines</bdi>

מדריך מלווה נוסף למרצה עבור [המצגת](AZ-104T00A-ENU-PowerPoint_08.pptx); הוא אינו משנה חומרים קיימים. מספור השקופיות הוא מספור המצגת; הכותרת “<bdi dir="ltr">Lab 09</bdi>” בשקופיות <bdi dir="ltr">26</bdi>–<bdi dir="ltr">27</bdi> מתייחסת כאן לתוכן <bdi dir="ltr">Lab 08</bdi> של ניהול <bdi dir="ltr">VMs.</bdi>

## מפת ההדגמות

| הדגמה | שקופיות | זמן משוער | עלות/מגבלה |
| ---: | ---: | ---: | ---: |
| <bdi dir="ltr">1.</bdi> יצירה וחיבור <bdi dir="ltr">SSH</bdi> מוגבל | <span dir="ltr">7–12, 30</span> | <bdi dir="ltr">25</bdi> דקות | <bdi dir="ltr">VM</bdi> קטנה, <bdi dir="ltr">disk</bdi> ו־<bdi dir="ltr">public IP</bdi> |
| <bdi dir="ltr">2. Resize</bdi> ודיסק נתונים | <span dir="ltr">8–10, 20, 26–27</span> | <bdi dir="ltr">20</bdi> דקות | <bdi dir="ltr">downtime</bdi> מתוכנן ודיסק קטן |
| <bdi dir="ltr">3. Availability zones</bdi> לעומת <bdi dir="ltr">availability set</bdi> | <span dir="ltr">16–19, 26–27</span> | <bdi dir="ltr">12</bdi> דקות | אשף בלבד |
| <bdi dir="ltr">4. VMSS</bdi> — <bdi dir="ltr">manual scaling</bdi> ותכנון <bdi dir="ltr">autoscale</bdi> | <span dir="ltr">20–22, 26–27</span> | <bdi dir="ltr">25</bdi> דקות + <bdi dir="ltr">provisioning</bdi> | אופציונלי בתשלום; עד שתי <bdi dir="ltr">instances</bdi> |

## הכנה ובטיחות

1. ב־<bdi dir="ltr">Azure portal > Settings > Directories + subscriptions</bdi> אמתו <bdi dir="ltr">Tenant</bdi> ו־<bdi dir="ltr">Subscription ID.</bdi> בכל אשף בחרו שוב את המנוי המאומת.
2. נדרש <bdi dir="ltr">Contributor</bdi> בקבוצת דמו חדשה. ב־<bdi dir="ltr">Subscriptions > Usage + quotas</bdi> בדקו <bdi dir="ltr">vCPU quota</bdi> גם אזורי וגם משפחתי: <bdi dir="ltr">`Standard_B2s`</bdi> דורש <bdi dir="ltr">2 vCPUs</bdi>; <bdi dir="ltr">resize</bdi> ל־<bdi dir="ltr">`Standard_B2ms`</bdi> עדיין דורש <bdi dir="ltr">2</bdi>; <bdi dir="ltr">VMSS</bdi> של שתי <bdi dir="ltr">instances</bdi> דורש <bdi dir="ltr">4</bdi> נוספים אם ה־<bdi dir="ltr">VM</bdi> היחידה עדיין קיימת. <bdi dir="ltr">SKU</bdi> ו־<bdi dir="ltr">capacity</bdi> אינם מובטחים.
3. צרו <bdi dir="ltr">`az104-demo08`</bdi> ב־<bdi dir="ltr">West Europe</bdi> עם <bdi dir="ltr">`Purpose=ClassroomDemo`</bdi>. אם השם קיים ולא נוצר לדמו שלכם, בחרו סיומת אחרת והתאימו את כל הצעדים.
4. המסלול הבסיסי משתמש ב־<bdi dir="ltr">SSH</bdi> ממחשב המרצה עם <bdi dir="ltr">public IP</bdi> מוגבל לכתובת <bdi dir="ltr">egress</bdi> אחת. אם מדיניות אוסרת <bdi dir="ltr">public IP</bdi> או <bdi dir="ltr">password authentication</bdi>, **אל תעקפו אותה**: בצעו את אשף היצירה בלי <bdi dir="ltr">Create</bdi>, או השתמשו ב־<bdi dir="ltr">Bastion/</bdi>חיבור פרטי מאושר שהוכן מראש. אין <bdi dir="ltr">free sandbox</bdi> מובטח.
5. סיסמת <bdi dir="ltr">administrator</bdi> ייחודית מוקלדת בפרטיות ואינה מופיעה במדריך, במסך משותף או בפקודה. אין להוריד <bdi dir="ltr">keys</bdi> או לחשוף <bdi dir="ltr">credentials.</bdi> רק תוכן פיקטיבי ב־<bdi dir="ltr">VM.</bdi>

## <bdi dir="ltr">1.</bdi> יצירה וחיבור ל־<bdi dir="ltr">VM</bdi>

**מטרה:** לחבר בין <bdi dir="ltr">image</bdi>, <bdi dir="ltr">size</bdi>, <bdi dir="ltr">network</bdi> ו־<bdi dir="ltr">disk</bdi>, ואז להוכיח חיבור למערכת ההפעלה.

**דרישות ומשאבים:** ההכנה לעיל, <bdi dir="ltr">OpenSSH client</bdi> במחשב המרצה, תעבורת <bdi dir="ltr">SSH</bdi> יוצאת מותרת. שמות: <bdi dir="ltr">`vnet-demo08`</bdi>, <bdi dir="ltr">`snet-vm`</bdi>, <bdi dir="ltr">`nsg-demo08`</bdi>, <bdi dir="ltr">`vm-demo08`</bdi>, <bdi dir="ltr">`pip-demo08`</bdi>.

### צעדים

1. <bdi dir="ltr">Virtual networks > Create:</bdi> <bdi dir="ltr">`vnet-demo08`</bdi>, <bdi dir="ltr">West Europe</bdi>, <bdi dir="ltr">`10.68.0.0/16`</bdi>; <bdi dir="ltr">subnet</bdi> <bdi dir="ltr">`snet-vm`</bdi> עם <bdi dir="ltr">`10.68.1.0/24`</bdi>. אין לחבר לרשת ארגונית או לרשתות מודול <bdi dir="ltr">06.</bdi>
2. <bdi dir="ltr">Network security groups > Create:</bdi> <bdi dir="ltr">`nsg-demo08`</bdi>. ב־<bdi dir="ltr">Inbound rules > Add:</bdi>
   - <span dir="ltr">Name `Allow-SSH-Instructor`, Priority `100`, Protocol TCP.</span>
   - <bdi dir="ltr">Source</bdi> **<bdi dir="ltr">IP Addresses</bdi>**, כתובת ה־<bdi dir="ltr">egress</bdi> הציבורית המאושרת של המרצה עם <bdi dir="ltr">`/32`</bdi>; <bdi dir="ltr">Source port</bdi> <bdi dir="ltr">`*`</bdi>.
   - <span dir="ltr">Destination Any, Destination port `22`, Allow.</span>
   - אין <bdi dir="ltr">Source</bdi> <bdi dir="ltr">`Any`</bdi>, אין פתיחת <bdi dir="ltr">RDP</bdi> ואין הרשאת <bdi dir="ltr">subnet</bdi> ארגוני רחב.
3. ב־<bdi dir="ltr">VNet > Subnets ></bdi> <bdi dir="ltr">`snet-vm`</bdi> שייכו <bdi dir="ltr">`nsg-demo08`</bdi>.
4. <bdi dir="ltr">Public IP addresses > Create:</bdi> <bdi dir="ltr">`pip-demo08`</bdi>, <bdi dir="ltr">Standard</bdi>, <bdi dir="ltr">IPv4</bdi>, <bdi dir="ltr">Static</bdi>, <bdi dir="ltr">West Europe</bdi>; <bdi dir="ltr">zone choice</bdi> שתואמת ל־<bdi dir="ltr">VM non-zonal</bdi> לפי האזור. זהו <bdi dir="ltr">IP</bdi> בתשלום גם אם ה־<bdi dir="ltr">VM</bdi> עצורה.
5. <bdi dir="ltr">Virtual machines > Create > Azure virtual machine:</bdi> המנוי והקבוצה, <bdi dir="ltr">`vm-demo08`</bdi>, <bdi dir="ltr">West Europe</bdi>, <bdi dir="ltr">Availability</bdi> **<bdi dir="ltr">No infrastructure redundancy required</bdi>**, <bdi dir="ltr">Security type Standard</bdi> אם נתמך ומאושר, <bdi dir="ltr">Ubuntu Server 24.04 LTS x64</bdi>, <bdi dir="ltr">size</bdi> <bdi dir="ltr">`Standard_B2s`</bdi>.
6. <bdi dir="ltr">Authentication: username</bdi> <bdi dir="ltr">`azureadmin`</bdi>, סיסמה ייחודית בשדות הפרטיים. <bdi dir="ltr">Public inbound ports</bdi> **<bdi dir="ltr">None</bdi>**. אין ליצור <bdi dir="ltr">key</bdi> לצורך הדמו.
7. <bdi dir="ltr">Disks: Standard SSD LRS OS disk.</bdi> ללא <bdi dir="ltr">data disks</bdi> עדיין; <bdi dir="ltr">Boot diagnostics</bdi> עם <bdi dir="ltr">managed storage</bdi> אם זמין, לא חשבון ארגוני.
8. <bdi dir="ltr">Networking:</bdi> <bdi dir="ltr">`vnet-demo08/snet-vm`</bdi>, <bdi dir="ltr">public IP</bdi> <bdi dir="ltr">`pip-demo08`</bdi>, <bdi dir="ltr">NIC NSG</bdi> **<bdi dir="ltr">None</bdi>** כי יש <bdi dir="ltr">NSG</bdi> ב־<bdi dir="ltr">subnet.</bdi> אל תפעילו <bdi dir="ltr">inbound ports</bdi> באשף. ה־<bdi dir="ltr">public IP</bdi> המשויך ל־<bdi dir="ltr">NIC</bdi> מספק נתיב <bdi dir="ltr">outbound</bdi> מפורש; אין להסתמך על <bdi dir="ltr">default outbound.</bdi>
9. <bdi dir="ltr">Management:</bdi> ללא <bdi dir="ltr">auto-shutdown</bdi> שאינו מתואם עם השיעור, ללא <bdi dir="ltr">Backup</bdi> או <bdi dir="ltr">Insights</bdi> בתשלום לצורך דמו זה. <bdi dir="ltr">Review + create:</bdi> בדקו עלות, <bdi dir="ltr">network</bdi> והיעדר <bdi dir="ltr">22</bdi> פתוח לכולם. <bdi dir="ltr">Create.</bdi>
10. אחרי <bdi dir="ltr">Succeeded</bdi>, <bdi dir="ltr">Overview:</bdi> ודאו <bdi dir="ltr">Running</bdi>, רשמו <bdi dir="ltr">public IP</bdi> ואת <bdi dir="ltr">private IP</bdi> בפועל. <bdi dir="ltr">Networking > Effective security rules:</bdi> אמתו <bdi dir="ltr">`Allow-SSH-Instructor`</bdi>.
11. במחשב המרצה, <bdi dir="ltr">PowerShell:</bdi> הקלידו את ה־<bdi dir="ltr">public IP</bdi> שאינו סוד מתוך <bdi dir="ltr">Overview</bdi> ובדקו קישוריות:

    <div dir="ltr" align="right">

    ```powershell
    $vmIp = Read-Host 'Public IP shown in VM Overview'
    Test-NetConnection -ComputerName $vmIp -Port 22
    ssh "azureadmin@$vmIp"
    ```

    </div>


12. בחיבור הראשון אמתו את <bdi dir="ltr">host identity</bdi> לפי נוהל הארגון; אל תדלגו על בדיקת <bdi dir="ltr">host key</bdi> ואל תשביתו <bdi dir="ltr">StrictHostKeyChecking.</bdi> הקלידו את הסיסמה בפרטיות, ללא <bdi dir="ltr">echo.</bdi>
13. בתוך <bdi dir="ltr">SSH:</bdi>

    <div dir="ltr" align="right">

    ```bash
    hostname
    uname -r
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS
    ```

    </div>


14. הראו ש־<bdi dir="ltr">hostname</bdi> הוא <bdi dir="ltr">`vm-demo08`</bdi> ושה־<bdi dir="ltr">OS disk</bdi> מופיע. סיימו ב־<bdi dir="ltr">`exit`</bdi>.

**תוצאה ואימות:** <bdi dir="ltr">TCP 22</bdi> נגיש רק ממקור מאושר, <bdi dir="ltr">SSH</bdi> מציג את שם המכונה. <bdi dir="ltr">Running</bdi> בפורטל לבדו אינו הוכחה לחיבור <bdi dir="ltr">SSH</bdi> או לבריאות יישום.

**תצפית הוראתית:** <bdi dir="ltr">IaaS</bdi> משאיר ניהול <bdi dir="ltr">OS</bdi> ועדכוני <bdi dir="ltr">guest</bdi> בידי הלקוח. <bdi dir="ltr">Public IP</bdi> אינו פותח <bdi dir="ltr">port</bdi> בלי <bdi dir="ltr">NSG</bdi>, ו־<bdi dir="ltr">NSG Allow</bdi> אינו מוכיח שה־<bdi dir="ltr">SSH daemon</bdi> מאזין.

**תקלות:** <bdi dir="ltr">quota/SKU unavailable</bdi> → גודל קטן מאושר או מסלול אשף. <bdi dir="ltr">timeout</bdi> → <bdi dir="ltr">IP egress</bdi> שונה בגלל <bdi dir="ltr">VPN</bdi>, <bdi dir="ltr">port 22</bdi> יוצא חסום, <bdi dir="ltr">NSG</bdi> נוסף על <bdi dir="ltr">NIC</bdi>, או <bdi dir="ltr">VM</bdi> אינה <bdi dir="ltr">Running. authentication failed</bdi> → <bdi dir="ltr">username/password</bdi>, לא <bdi dir="ltr">firewall.</bdi> אין לפתוח <bdi dir="ltr">`Any`</bdi> כדי “לבדוק”.

**ניקוי:** השאירו עד הדגמה <bdi dir="ltr">2.</bdi> אם עושים רק דמו זה, מחקו את קבוצת הדמו אחרי בדיקת דיסקים/<bdi dir="ltr">IPs. Deallocate</bdi> מפסיק <bdi dir="ltr">compute</bdi>, לא <bdi dir="ltr">storage/IP charges.</bdi>

## <bdi dir="ltr">2. Resize</bdi> ודיסק נתונים — ללא פעולת <bdi dir="ltr">format</bdi>

**מטרה:** להבדיל <bdi dir="ltr">vertical scaling</bdi> מהוספת <bdi dir="ltr">storage</bdi> ולהראות שמערכת ההפעלה צריכה לגלות דיסק חדש.

**דרישות ומשאבים:** <bdi dir="ltr">`vm-demo08`</bdi> מהדגמה <bdi dir="ltr">1</bdi>; הרשאת <bdi dir="ltr">write</bdi> ל־<bdi dir="ltr">VM/disks.</bdi> יעד <bdi dir="ltr">resize</bdi> <bdi dir="ltr">`Standard_B2ms`</bdi> אם זמין. דיסק חדש <bdi dir="ltr">`disk-demo08-data`</bdi>, <bdi dir="ltr">Standard SSD LRS</bdi>, <bdi dir="ltr">`32 GiB`</bdi>, <bdi dir="ltr">LUN</bdi> <bdi dir="ltr">`0`</bdi>.

### צעדים

1. בתוך <bdi dir="ltr">SSH</bdi> רשמו <bdi dir="ltr">`free -h`</bdi> ו־<bdi dir="ltr">`lsblk`</bdi>. אל תשמרו נתוני דמו חשובים ב־<bdi dir="ltr">temporary disk.</bdi>
2. סגרו <bdi dir="ltr">SSH. VM > Stop</bdi>; המתינו ל־**<bdi dir="ltr">Stopped</bdi> (<bdi dir="ltr">deallocated</bdi>)**. הסבירו ש־<bdi dir="ltr">shutdown</bdi> בתוך <bdi dir="ltr">OS</bdi> לא בהכרח מפסיק חיוב <bdi dir="ltr">compute.</bdi>
3. <bdi dir="ltr">VM > Size:</bdi> חפשו <bdi dir="ltr">`Standard_B2ms`</bdi>, בדקו מחיר ו־<bdi dir="ltr">quota</bdi>, בחרו <bdi dir="ltr">Resize.</bdi> אם אינו זמין, הציגו רשימה בלבד בלי לבחור גודל גדול יקר.
4. <bdi dir="ltr">Start</bdi>, המתינו ל־<bdi dir="ltr">Running</bdi>, התחברו שוב דרך אותו <bdi dir="ltr">Static public IP.</bdi> <bdi dir="ltr">`free -h`</bdi> אמור להראות יותר זיכרון אם <bdi dir="ltr">resize</bdi> אכן בוצע; <bdi dir="ltr">hostname</bdi> נשאר זהה.
5. <bdi dir="ltr">VM > Disks > Create and attach a new disk:</bdi> שם <bdi dir="ltr">`disk-demo08-data`</bdi>, <bdi dir="ltr">Standard SSD LRS</bdi>, <bdi dir="ltr">`32 GiB`</bdi>, ללא <bdi dir="ltr">shared disk</bdi>; <bdi dir="ltr">LUN</bdi> <bdi dir="ltr">`0`</bdi>, <bdi dir="ltr">caching</bdi> לפי ההמלצה באשף. <bdi dir="ltr">Apply / Save.</bdi>
6. התחברו מחדש או המתינו לגילוי הדיסק:

    <div dir="ltr" align="right">

    ```bash
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS
    ```

    </div>


7. השוו לרשימה הראשונה: אמור להופיע <bdi dir="ltr">device</bdi> נוסף של כ־<bdi dir="ltr">32 GiB</bdi> ללא <bdi dir="ltr">mountpoint.</bdi> **אין לנחש <bdi dir="ltr">`/dev/sdc`</bdi> ואין להריץ <bdi dir="ltr">mkfs/fdisk</bdi>** — ההדגמה מסתיימת לפני פעולה הרסנית.
8. ב־<bdi dir="ltr">Disks</bdi> הציגו את ההפרדה בין <bdi dir="ltr">managed OS disk</bdi> ל־<bdi dir="ltr">data disk</bdi> ואת הגדרת <bdi dir="ltr">Delete with VM. Temporary disk</bdi> יכול להיות חסר ב־<bdi dir="ltr">SKU</bdi> מסוימים ואינו אחסון עמיד.
9. אם צריך להחזיר עלות נמוכה, <bdi dir="ltr">Stop/deallocate</bdi>, <bdi dir="ltr">Size</bdi> → <bdi dir="ltr">`Standard_B2s`</bdi>, <bdi dir="ltr">Resize</bdi> ואז <bdi dir="ltr">Start</bdi> רק להמשך שיעור. ציינו <bdi dir="ltr">downtime</bdi>, לא <bdi dir="ltr">zero-downtime resize.</bdi>

**תוצאה ואימות:** <bdi dir="ltr">Size</bdi> בפורטל תואם לשינוי ו־<bdi dir="ltr">guest</bdi> רואה <bdi dir="ltr">disk</bdi> נוסף. <bdi dir="ltr">Attached</bdi> אינו <bdi dir="ltr">Mounted</bdi> ואינו <bdi dir="ltr">formatted.</bdi>

**תצפית הוראתית:** <bdi dir="ltr">Resize</bdi> מגדיל <bdi dir="ltr">VM</bdi> אחת; <bdi dir="ltr">disk capacity</bdi> אינה <bdi dir="ltr">CPU scaling.</bdi> שינוי גודל עלול לדרוש <bdi dir="ltr">deallocation</bdi> בגלל <bdi dir="ltr">hardware cluster.</bdi>

**תקלות:** <bdi dir="ltr">SKU</bdi> לא ברשימה → <bdi dir="ltr">region/capacity</bdi> או מגבלת משפחה; <bdi dir="ltr">quota</bdi> אינו <bdi dir="ltr">capacity. disk</bdi> לא מופיע → <bdi dir="ltr">Apply</bdi> לא הושלם, <bdi dir="ltr">OS</bdi> עדיין מגלה אותו, <bdi dir="ltr">LUN</bdi> כבר תפוס. אין להגדיל <bdi dir="ltr">OS disk</bdi> לצורך דמו קטן: אי אפשר פשוט להקטין אותו בחזרה.

**ניקוי:** מאחר שהדיסק לא פורמט ולא <bdi dir="ltr">mounted</bdi>, ב־<bdi dir="ltr">Disks</bdi> נתקו רק <bdi dir="ltr">`disk-demo08-data`</bdi>, <bdi dir="ltr">Save</bdi> ואז מחקו את המשאב ב־<bdi dir="ltr">Disks</bdi> לאחר אימות <bdi dir="ltr">unattached.</bdi> ודאו שלא נבחר <bdi dir="ltr">OS disk.</bdi> השאירו <bdi dir="ltr">VM</bdi> רק אם צריך אותה; אין תלות שלה בהדגמות <bdi dir="ltr">3</bdi>–<bdi dir="ltr">4.</bdi>

## <bdi dir="ltr">3. Availability zones</bdi> ו־<bdi dir="ltr">Availability set</bdi> — אשף ללא פריסה

**מטרה:** להסביר <bdi dir="ltr">fault/update domains</bdi> והבדל בין רמת <bdi dir="ltr">rack</bdi> לרמת <bdi dir="ltr">datacenter.</bdi>

**דרישות ומשאבים:** <bdi dir="ltr">Reader</bdi> לסקירת <bdi dir="ltr">VM</bdi>; <bdi dir="ltr">Contributor</bdi> לפתיחת טיוטת יצירה בקבוצת הדמו. שמות טיוטה <bdi dir="ltr">`vm-zone-demo08`</bdi>, <bdi dir="ltr">`as-demo08`</bdi>; אינם נוצרים.

### צעדים

1. פתחו את <bdi dir="ltr">`vm-demo08`</bdi> > <bdi dir="ltr">Overview / Properties</bdi> והראו שאין <bdi dir="ltr">availability set/zone</bdi> שנבחרו ביצירה.
2. <bdi dir="ltr">Virtual machines > Create:</bdi> <bdi dir="ltr">`vm-zone-demo08`</bdi>, <bdi dir="ltr">West Europe</bdi>; ב־<bdi dir="ltr">Availability options</bdi> בחרו <bdi dir="ltr">Availability zone.</bdi> הציגו <bdi dir="ltr">zones</bdi> הזמינים ושימו לב לתאימות <bdi dir="ltr">image/size.</bdi> אין <bdi dir="ltr">Create.</bdi>
3. הסבירו: שתי <bdi dir="ltr">VMs</bdi> בשני <bdi dir="ltr">zones</bdi> ונתיב <bdi dir="ltr">frontend</bdi> מתאים הם תכנון עמיד יותר; בחירת <bdi dir="ltr">zone</bdi> עבור <bdi dir="ltr">VM</bdi> יחידה אינה יוצרת <bdi dir="ltr">VM</bdi> נוספת או <bdi dir="ltr">load balancer.</bdi>
4. החליפו ל־<bdi dir="ltr">Availability set</bdi>, פתחו <bdi dir="ltr">Create new</bdi> <bdi dir="ltr">`as-demo08`</bdi> בתוך הטיוטה. הציגו <bdi dir="ltr">Fault domains</bdi> ו־<bdi dir="ltr">Update domains</bdi>; בחרו לצורך תכנון <bdi dir="ltr">`2`</bdi> ו־<bdi dir="ltr">`5`</bdi> אם נתמכים באזור, <bdi dir="ltr">Managed disks.</bdi>
5. אל תאשרו יצירה נפרדת של <bdi dir="ltr">set</bdi> אם האשף עושה <bdi dir="ltr">deployment</bdi> מיידי; בטלו. <bdi dir="ltr">VM</bdi> קיימת אינה ניתנת פשוט להעברה ל־<bdi dir="ltr">set</bdi> דרך שינוי שדה.
6. מול שקופית <bdi dir="ltr">19</bdi> הציגו <bdi dir="ltr">maintenance</bdi> של <bdi dir="ltr">update domain</bdi> אחד בכל פעם, לעומת כשל <bdi dir="ltr">hardware</bdi> שמשפיע על <bdi dir="ltr">fault domain.</bdi>
7. השליכו טיוטה. <bdi dir="ltr">Azure Arc</bdi> בשקופית <bdi dir="ltr">23</bdi> הוא סקירה אופציונלית: אין להתקין <bdi dir="ltr">agent</bdi> או לרשום מחשב מרצה.

**תוצאה ואימות:** קבוצת הדמו עדיין אינה מכילה <bdi dir="ltr">`vm-zone-demo08`</bdi> או <bdi dir="ltr">`as-demo08`</bdi>. לא התבצע <bdi dir="ltr">failover</bdi> או מבחן <bdi dir="ltr">SLA.</bdi>

**תצפית הוראתית:** ערכי <bdi dir="ltr">SLA</bdi> תלויים במספר <bdi dir="ltr">instances</bdi>, סוג דיסקים ותנאי השירות; “<bdi dir="ltr">zone</bdi>” אינו הבטחת <bdi dir="ltr">SLA</bdi> של <bdi dir="ltr">99.99</bdi>% ל־<bdi dir="ltr">VM</bdi> יחידה.

**תקלות:** <bdi dir="ltr">zone</bdi> לא נתמך ב־<bdi dir="ltr">SKU/region</bdi>; מספר <bdi dir="ltr">fault domains</bdi> מוגבל באזור. אין להתקדם עם אזור אחר ו־<bdi dir="ltr">network</bdi> מהאזור הישן.

**ניקוי:** בטלו טיוטות; אם נוצר <bdi dir="ltr">set</bdi> ריק בטעות, מחקו רק אותו לאחר אימות שאין בו <bdi dir="ltr">VMs.</bdi>

## <bdi dir="ltr">4. VM Scale Set</bdi> — עד שתי <bdi dir="ltr">instances</bdi>

**מטרה:** לבצע <bdi dir="ltr">manual scale out/scale in</bdi> ולתכנן <bdi dir="ltr">autoscale</bdi> בשקופית <bdi dir="ltr">22.</bdi> הפריסה אופציונלית; בהיעדר <bdi dir="ltr">quota</bdi> הציגו את האשף והדוגמאות הרשמיות בלבד.

**דרישות ומשאבים:** <bdi dir="ltr">Contributor</bdi>, <bdi dir="ltr">quota</bdi> עד <bdi dir="ltr">4 vCPUs</bdi> נוספים, רשת מהדגמה <bdi dir="ltr">1. VMSS</bdi> <bdi dir="ltr">`vmss-demo08`</bdi>, ללא <bdi dir="ltr">public IPs</bdi>, ללא <bdi dir="ltr">Load Balancer</bdi>, ללא יישום; אין צורך ב־<bdi dir="ltr">SSH</bdi> או <bdi dir="ltr">outbound</bdi> להתקנת תוכנה.

### צעדים

1. <bdi dir="ltr">Virtual machine scale sets > Create:</bdi> <bdi dir="ltr">`az104-demo08`</bdi>, <bdi dir="ltr">`vmss-demo08`</bdi>, <bdi dir="ltr">West Europe</bdi>, <bdi dir="ltr">Orchestration</bdi> **<bdi dir="ltr">Uniform</bdi>**, ללא <bdi dir="ltr">Spot</bdi>, <bdi dir="ltr">Ubuntu 24.04 LTS</bdi>, <bdi dir="ltr">`Standard_B2s`</bdi>, <bdi dir="ltr">initial instance count</bdi> <bdi dir="ltr">`1`</bdi>.
2. בחרו <bdi dir="ltr">non-zonal</bdi> לצמצום תלויות <bdi dir="ltr">capacity</bdi>; בשיעור אפשר להציג <bdi dir="ltr">multi-zone</bdi> אך לא לשנות בלי <bdi dir="ltr">quota</bdi> מתאים.
3. <bdi dir="ltr">Authentication: username</bdi> <bdi dir="ltr">`azureadmin`</bdi>, סיסמה פרטית. <bdi dir="ltr">Disks: Standard SSD LRS. Networking:</bdi> <bdi dir="ltr">`vnet-demo08/snet-vm`</bdi>, ללא <bdi dir="ltr">public IP per instance</bdi>, ללא <bdi dir="ltr">inbound ports</bdi>, **<bdi dir="ltr">Load balancing</bdi> = <bdi dir="ltr">None</bdi>**. אין צורך ב־<bdi dir="ltr">LB</bdi> כדי להדגים מספר <bdi dir="ltr">instances</bdi>; אין הבטחה לשירות <bdi dir="ltr">web.</bdi>
4. <bdi dir="ltr">Management/Health:</bdi> ללא <bdi dir="ltr">automatic instance repairs</bdi> שאינם מוגדרים עם <bdi dir="ltr">health source</bdi>, ללא <bdi dir="ltr">extensions/Insights</bdi>; <bdi dir="ltr">Upgrade policy Manual</bdi> אם מוצגת. <bdi dir="ltr">Scaling mode Manual.</bdi>
5. <bdi dir="ltr">Review + create:</bdi> בדקו <bdi dir="ltr">`1`</bdi> <bdi dir="ltr">instance</bdi> ורשימת משאבים, ואז <bdi dir="ltr">Create</bdi> רק אם העלות מאושרת. המתינו ל־<bdi dir="ltr">Succeeded</bdi> וב־<bdi dir="ltr">Instances</bdi> ספרו <bdi dir="ltr">instance</bdi> אחת.
6. <bdi dir="ltr">Scaling > Manual scale: Instance count</bdi> <bdi dir="ltr">`2`</bdi> > <bdi dir="ltr">Save.</bdi> המתינו עד שב־<bdi dir="ltr">Instances</bdi> מופיעות שתי מכונות עם <bdi dir="ltr">Provisioning succeeded.</bdi>
7. החזירו <bdi dir="ltr">count</bdi> ל־<bdi dir="ltr">`1`</bdi> > <bdi dir="ltr">Save.</bdi> אמתו ש־<bdi dir="ltr">instance</bdi> אחת הוסרה. הסבירו ש־<bdi dir="ltr">scale-in</bdi> אינו שומר באופן אוטומטי נתונים מקומיים של <bdi dir="ltr">VM</bdi> שנמחקה.
8. <bdi dir="ltr">Scaling > Custom autoscale</bdi>, לצפייה בלבד:
   - <span dir="ltr">Min `1`, Default `1`, Max `2`.</span>
   - <bdi dir="ltr">Rule 1: Percentage CPU</bdi>, <bdi dir="ltr">Average ></bdi> <bdi dir="ltr">`70%`</bdi> למשך <bdi dir="ltr">`10`</bdi> דקות, <bdi dir="ltr">Increase count by</bdi> <bdi dir="ltr">`1`</bdi>, <bdi dir="ltr">Cooldown</bdi> <bdi dir="ltr">`5`</bdi> דקות.
   - <bdi dir="ltr">Rule 2: Percentage CPU</bdi>, <bdi dir="ltr">Average</bdi> < <bdi dir="ltr">`30%`</bdi> למשך <bdi dir="ltr">`10`</bdi> דקות, <bdi dir="ltr">Decrease count by</bdi> <bdi dir="ltr">`1`</bdi>, <bdi dir="ltr">Cooldown</bdi> <bdi dir="ltr">`5`</bdi> דקות.
9. הציגו את שני הכללים אך **אל תשמרו <bdi dir="ltr">autoscale</bdi>** במסלול הבסיסי. אין <bdi dir="ltr">workload</bdi> שמייצר עומס; <bdi dir="ltr">metric/cooldown/provisioning</bdi> לא מבטיחים <bdi dir="ltr">scale event</bdi> במהלך השיעור.
10. <bdi dir="ltr">Scale-in policy:</bdi> הציגו <bdi dir="ltr">default/oldest/newest options</bdi> אם זמינות. בלי יישום ובלי <bdi dir="ltr">state</bdi>, אין צורך לבחור מדיניות חדשה לצורך הדמו.

**תוצאה ואימות:** מעבר נמדד <bdi dir="ltr">1</bdi> → <bdi dir="ltr">2</bdi> → <bdi dir="ltr">1</bdi> ב־<bdi dir="ltr">Instances</bdi>, לא רק <bdi dir="ltr">desired count. Autoscale</bdi> הוצג כטיוטה ולא הוכח בעומס.

**תצפית הוראתית:** <bdi dir="ltr">VMSS</bdi> ללא <bdi dir="ltr">LB</bdi> עדיין יכול לשנות כמות מכונות; הוא לא מפיץ תעבורת <bdi dir="ltr">HTTP</bdi> מעצמו. <bdi dir="ltr">Scale-out</bdi> דורש גם פריסת יישום אחידה ותלויות חיצוניות מוכנות.

**תקלות:** <bdi dir="ltr">desired count 2</bdi> אבל <bdi dir="ltr">provisioning</bdi> נכשל → <bdi dir="ltr">Activity log</bdi> ו־<bdi dir="ltr">quota/capacity. Custom autoscale</bdi> עם <bdi dir="ltr">min/max</bdi> לא עקביים → תקנו לפני שמירה, לא העלאת <bdi dir="ltr">max</bdi> בלתי מוגבלת. <bdi dir="ltr">Uniform/Flexible</bdi> מציגים <bdi dir="ltr">workflows</bdi> שונים; הדמו מוגדר <bdi dir="ltr">Uniform</bdi> במפורש.

**ניקוי סופי:** מחקו את <bdi dir="ltr">`vmss-demo08`</bdi> ואת <bdi dir="ltr">disks/NICs</bdi> שנותרו ושייכים לו בלבד. לבסוף מחקו <bdi dir="ltr">`az104-demo08`</bdi> לאחר סקירת <bdi dir="ltr">ownership</bdi>; ודאו היעדר <bdi dir="ltr">`pip-demo08`</bdi> ודיסק הנתונים. אין למחוק משאבי <bdi dir="ltr">Backup</bdi> אם בחרתם להשתמש ב־<bdi dir="ltr">VM</bdi> במודול <bdi dir="ltr">10</bdi> לפני שסיימתם את ניקוי ההגנה שם.

## מקורות <bdi dir="ltr">Microsoft</bdi>

- [יצירת <bdi dir="ltr">Linux VM</bdi> בפורטל](https://learn.microsoft.com/azure/virtual-machines/linux/quick-create-portal)
- [גדלי <bdi dir="ltr">VMs</bdi>](https://learn.microsoft.com/azure/virtual-machines/sizes/overview)
- <span dir="ltr">[Resize](https://learn.microsoft.com/azure/virtual-machines/sizes/resize-vm)</span>
- [צירוף <bdi dir="ltr">data disk</bdi>](https://learn.microsoft.com/azure/virtual-machines/linux/attach-disk-portal)
- <span dir="ltr">[Availability sets](https://learn.microsoft.com/azure/virtual-machines/availability-set-overview)</span>
- <span dir="ltr">[Availability zones](https://learn.microsoft.com/azure/reliability/availability-zones-overview)</span>
- [<bdi dir="ltr">Autoscale</bdi> בפורטל](https://learn.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-portal)

</div>
