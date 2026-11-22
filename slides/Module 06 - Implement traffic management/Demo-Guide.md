<div dir="rtl" align="right">

# מודול <bdi dir="ltr">06</bdi> — הדגמות ניהול תעבורת רשת

מדריך מלווה נוסף למרצה עבור [המצגת](AZ-104T00A-ENU-PowerPoint_06.pptx), לפי השקופיות והערות המרצה. הוא אינו מחליף או משנה את [הדמו הקיים](Demo-NetworkWatcher.md), [סקריפט ההקמה](Deploy-NetworkMonitor.ps1) או [התבנית](main.bicep). ההדגמות אינן מניחות שסביבת <bdi dir="ltr">Lab 06</bdi> כבר קיימת. במסלול החסכוני מציגים את אשפי <bdi dir="ltr">Load Balancer</bdi> ו־<bdi dir="ltr">Application Gateway</bdi> בלי לפרוס אותם; הדגמת <bdi dir="ltr">Network Watcher</bdi> משתמשת בשתי מכונות קטנות בלבד.

## מפת ההדגמות

| הדגמה | שקופיות | זמן משוער | אופי |
| ---: | ---: | ---: | ---: |
| <bdi dir="ltr">1.</bdi> בחירת <bdi dir="ltr">Load Balancer</bdi> ומיפוי כלל | <span dir="ltr">3, 6–13, 33–34</span> | <bdi dir="ltr">15</bdi> דקות | אשף ללא יצירה |
| <bdi dir="ltr">2. Application Gateway</bdi> וניתוב לפי נתיב | <span dir="ltr">17–19, 35</span> | <bdi dir="ltr">15</bdi> דקות | אשף ללא יצירה |
| <bdi dir="ltr">3. Topology</bdi>, <bdi dir="ltr">Next hop</bdi> ותקלה מבוקרת ב־<bdi dir="ltr">NSG</bdi> | <span dir="ltr">23–24, 26–30</span> | <bdi dir="ltr">25</bdi> דקות + <bdi dir="ltr">15</bdi>–<bdi dir="ltr">30</bdi> הכנה | שתי <bdi dir="ltr">VMs</bdi> בתשלום |
| <bdi dir="ltr">4. Connection Monitor</bdi> ו־<bdi dir="ltr">VNet flow logs</bdi> | <span dir="ltr">24–25</span> | <bdi dir="ltr">12</bdi> דקות | סקירת הגדרות ללא הפעלה |

## כללי פתיחה ובטיחות

1. היכנסו ל־[<bdi dir="ltr">Azure portal</bdi>](https://portal.azure.com). ב־<bdi dir="ltr">Settings > Directories + subscriptions</bdi> אמתו את ה־<bdi dir="ltr">Tenant</bdi> ואת ה־<bdi dir="ltr">Subscription ID</bdi> מול חשבון ההדרכה. בחרו שוב את אותו מנוי בכל אשף.
2. בדקו ב־<bdi dir="ltr">Subscriptions > Usage + quotas</bdi> זמינות של לפחות <bdi dir="ltr">4 vCPUs</bdi> ממשפחת <bdi dir="ltr">B</bdi> באזור <bdi dir="ltr">`West Europe`</bdi>. אם <bdi dir="ltr">`Standard_B2s`</bdi> אינו זמין, בחרו גודל קטן מאושר; אין הבטחה לזמינות <bdi dir="ltr">SKU.</bdi> אל תעברו לאזור אחר בלי לעדכן את כל הבחירות.
3. להקמה נדרש <bdi dir="ltr">Contributor</bdi> בקבוצת משאבים ייעודית; לכלי <bdi dir="ltr">Network Watcher</bdi> נדרשות גם פעולות האבחון המתאימות והגישה ל־<bdi dir="ltr">Network Watcher</bdi> האזורי. <bdi dir="ltr">Reader</bdi> מספיק לסקירת סביבה קיימת מאושרת, אך לא לבדיקות הדורשות <bdi dir="ltr">action.</bdi>
4. צרו קבוצת משאבים חדשה <bdi dir="ltr">`az104-demo06`</bdi> ב־<bdi dir="ltr">West Europe</bdi> עם תג <bdi dir="ltr">`Purpose=ClassroomDemo`</bdi>. אם השם תפוס, עצרו ובחרו סיומת נפרדת; אין להשתמש בקבוצה קיימת של אחרים.
5. לא מציגים סיסמה, <bdi dir="ltr">SSH private key</bdi>, <bdi dir="ltr">SAS</bdi> או <bdi dir="ltr">connection string.</bdi> את סיסמת ה־<bdi dir="ltr">VM</bdi> מקלידים באופן פרטי בשדה האשף בלבד. אין לפתוח כניסת <bdi dir="ltr">SSH/RDP</bdi> מהאינטרנט.
6. שמות תפריטים משתנים. חפשו את שם השירות אם הנתיב השתנה. תוצאת אשף אינה בדיקת תקינות של שירות פעיל.

## <bdi dir="ltr">1.</bdi> בחירת <bdi dir="ltr">Load Balancer</bdi> ומיפוי כלל

**מטרה:** לחבר בין <bdi dir="ltr">Layer 4</bdi>, <bdi dir="ltr">frontend</bdi>, <bdi dir="ltr">backend pool</bdi> ו־<bdi dir="ltr">health probe</bdi>; הדגמת שקופית <bdi dir="ltr">12</bdi> מבקשת גם <bdi dir="ltr">review settings</bdi>, לא בהכרח פריסה.

**דרישות ומשאבים:** הרשאת צפייה במנוי, ובמסלול האשף <bdi dir="ltr">Contributor</bdi> ב־<bdi dir="ltr">`az104-demo06`</bdi>. אין צורך ב־<bdi dir="ltr">VMs.</bdi> שמות לתכנון בלבד: <bdi dir="ltr">`lb-demo06`</bdi>, <bdi dir="ltr">`pip-lb-demo06`</bdi>, <bdi dir="ltr">`frontend-web`</bdi>, <bdi dir="ltr">`pool-web`</bdi>, <bdi dir="ltr">`probe-http`</bdi>, <bdi dir="ltr">`rule-http`</bdi>.

### צעדים

1. חפשו <bdi dir="ltr">`Load balancing`</bdi> ופתחו **<bdi dir="ltr">Help me choose</bdi>** אם זמין. ענו: <bdi dir="ltr">HTTP/HTTPS</bdi>, <bdi dir="ltr">public</bdi>, אזור יחיד; הציגו את המלצת <bdi dir="ltr">Layer 7.</bdi> שנו לתעבורת <bdi dir="ltr">TCP</bdi> שאינה <bdi dir="ltr">HTTP</bdi> והסבירו מדוע <bdi dir="ltr">Load Balancer</bdi> מתאים.
2. פתחו <bdi dir="ltr">Load balancers > Create.</bdi> בחרו את המנוי המאומת, הקבוצה, <bdi dir="ltr">West Europe</bdi>, שם <bdi dir="ltr">`lb-demo06`</bdi>, <bdi dir="ltr">SKU</bdi> **<bdi dir="ltr">Standard</bdi>**, <bdi dir="ltr">Type</bdi> **<bdi dir="ltr">Public</bdi>**, <bdi dir="ltr">Tier</bdi> **<bdi dir="ltr">Regional</bdi>**.
3. ב־<bdi dir="ltr">Frontend IP configuration</bdi> בחרו <bdi dir="ltr">Add</bdi>, שם <bdi dir="ltr">`frontend-web`</bdi>, <bdi dir="ltr">IPv4</bdi> ו־<bdi dir="ltr">Create new public IP</bdi> בשם <bdi dir="ltr">`pip-lb-demo06`</bdi>, <bdi dir="ltr">SKU Standard</bdi>, <bdi dir="ltr">Static.</bdi> אל תאשרו יצירה עצמאית אם הממשק מבקש לפרוס את ה־<bdi dir="ltr">IP</bdi> מיד; במקרה כזה הסתפקו בצפייה בשדות.
4. ב־<bdi dir="ltr">Backend pools > Add</bdi> הציגו שם <bdi dir="ltr">`pool-web`</bdi> ואת הבחירה בין <bdi dir="ltr">NIC</bdi> ו־<bdi dir="ltr">IP address.</bdi> **אל תבחרו את שתי מכונות ההדגמה הבאה יחד:** הן ב־<bdi dir="ltr">VNets</bdi> שונים; <bdi dir="ltr">backend pool</bdi> רגיל של <bdi dir="ltr">Standard Load Balancer</bdi> אינו בריכת מכונות משני <bdi dir="ltr">VNets</bdi> באמצעות <bdi dir="ltr">peering.</bdi>
5. פתחו הוספת <bdi dir="ltr">rule</bdi> אם האשף מאפשר זאת: <bdi dir="ltr">`rule-http`</bdi>, <bdi dir="ltr">frontend</bdi> <bdi dir="ltr">`frontend-web`</bdi>, <bdi dir="ltr">TCP</bdi>, <bdi dir="ltr">frontend port</bdi> <bdi dir="ltr">`80`</bdi>, <bdi dir="ltr">backend port</bdi> <bdi dir="ltr">`80`</bdi>, <bdi dir="ltr">pool</bdi> <bdi dir="ltr">`pool-web`</bdi>. פתחו <bdi dir="ltr">Health probe > Create new:</bdi> <bdi dir="ltr">`probe-http`</bdi>, <bdi dir="ltr">HTTP</bdi>, <bdi dir="ltr">port</bdi> <bdi dir="ltr">`80`</bdi>, <bdi dir="ltr">path</bdi> <bdi dir="ltr">`/`</bdi>. אם האשף דורש <bdi dir="ltr">backend</bdi> קיים, הציגו את השדות הזמינים בלבד; אין להמציא <bdi dir="ltr">NIC.</bdi>
6. הציגו <bdi dir="ltr">Session persistence: None</bdi>, <bdi dir="ltr">Client IP</bdi>, <bdi dir="ltr">Client IP and protocol.</bdi> החזירו ל־<bdi dir="ltr">None.</bdi> הפרידו בין <bdi dir="ltr">load-balancing rule</bdi> לבין <bdi dir="ltr">inbound NAT rule</bdi> המכוון למכונה מסוימת.
7. חזרו ל־<bdi dir="ltr">Basics</bdi> ושנו <bdi dir="ltr">Type</bdi> ל־<bdi dir="ltr">Internal.</bdi> הציגו בחירת <bdi dir="ltr">VNet/subnet</bdi> ו־<bdi dir="ltr">private frontend IP.</bdi> אם טרם נוצר <bdi dir="ltr">VNet</bdi>, זו רשימה ריקה צפויה; אחרי הכנת הדגמה <bdi dir="ltr">3</bdi> ניתן לבחור <bdi dir="ltr">`vnet-nm1`</bdi> / <bdi dir="ltr">`snet-nm1`</bdi> לצורך תצוגה בלבד.
8. סגרו את האשף ב־<bdi dir="ltr">Cancel / Discard.</bdi> אין ללחוץ <bdi dir="ltr">Create.</bdi>

**תוצאה ואימות:** התלמידים מזהים את שרשרת <bdi dir="ltr">frontend</bdi> → <bdi dir="ltr">rule</bdi> → <bdi dir="ltr">pool</bdi> → <bdi dir="ltr">probe.</bdi> בדקו ב־<bdi dir="ltr">Resource group</bdi> שלא נוצרו <bdi dir="ltr">`lb-demo06`</bdi> או <bdi dir="ltr">`pip-lb-demo06`</bdi>. אין כתובת פעילה ואין תוצאה של איזון עומס.

**תצפית הוראתית:** <bdi dir="ltr">HTTP probe</bdi> דורש שרת <bdi dir="ltr">HTTP</bdi> שעונה בהצלחה לנתיב; שרת <bdi dir="ltr">SSH</bdi> אינו <bdi dir="ltr">backend</bdi> מתאים ל־<bdi dir="ltr">probe</bdi> כזה. קריאות חוזרות מאותו לקוח אינן מבטיחות <bdi dir="ltr">alternation</bdi> בין מכונות.

**תקלות:** רשימת <bdi dir="ltr">backend</bdi> ריקה אינה <bdi dir="ltr">quota error</bdi>; אין <bdi dir="ltr">VMs</bdi> באותו <bdi dir="ltr">VNet. Standard</bdi> דורש <bdi dir="ltr">Standard public IP.</bdi> אין להשתמש ב־<bdi dir="ltr">Basic SKU</bdi> המיושן. פריסה מלאה מחייבת גם <bdi dir="ltr">NSG</bdi> לכניסת היישום ול־<bdi dir="ltr">AzureLoadBalancer probes</bdi> ונתיב <bdi dir="ltr">outbound</bdi> מפורש להתקנת היישום.

**ניקוי:** השליכו טיוטות. אם נוצר בטעות רק <bdi dir="ltr">IP</bdi> של ההדגמה, מחקו אותו לאחר בדיקת שיוך; אין למחוק <bdi dir="ltr">IP</bdi> משויך למשאב אחר.

## <bdi dir="ltr">2. Application Gateway</bdi> וניתוב לפי נתיב

**מטרה:** להראות <bdi dir="ltr">listener</bdi>, <bdi dir="ltr">backend settings</bdi> ו־<bdi dir="ltr">path-based routing</bdi> של <bdi dir="ltr">`/images/*`</bdi> ו־<bdi dir="ltr">`/videos/*`</bdi>, בהתאם לשקופיות <bdi dir="ltr">18</bdi> ו־<bdi dir="ltr">35.</bdi>

**דרישות ומשאבים:** <bdi dir="ltr">Contributor</bdi> בקבוצה לצפייה באשף. אין <bdi dir="ltr">backend</bdi> חי ואין אתר אמיתי בדמו זה. שמות לתכנון: <bdi dir="ltr">`agw-demo06`</bdi>, <bdi dir="ltr">`pip-agw-demo06`</bdi>, <bdi dir="ltr">`vnet-agw-demo06`</bdi>, <bdi dir="ltr">`snet-appgw`</bdi>, <bdi dir="ltr">`pool-images`</bdi>, <bdi dir="ltr">`pool-videos`</bdi>.

### צעדים

1. <bdi dir="ltr">Application gateways > Create:</bdi> המנוי המאומת, <bdi dir="ltr">`az104-demo06`</bdi>, <bdi dir="ltr">West Europe</bdi>, <bdi dir="ltr">`agw-demo06`</bdi>, <bdi dir="ltr">tier</bdi> **<bdi dir="ltr">Standard_v2</bdi>**. הציגו עלות קבועה/קיבולת; <bdi dir="ltr">WAF_v2</bdi> הוא תוספת בתשלום, לא תנאי להדגמה.
2. הציגו <bdi dir="ltr">Scale units / Autoscaling</bdi> ומינימום קיבולת לפי האשף. אין לטעון שמינימום אפס מבטל את כלל החיובים.
3. תחת <bdi dir="ltr">Virtual network</bdi> בחרו <bdi dir="ltr">Create new</bdi> לתכנון: <bdi dir="ltr">`vnet-agw-demo06`</bdi>, מרחב <bdi dir="ltr">`10.66.0.0/16`</bdi>, <bdi dir="ltr">subnet</bdi> ייעודי <bdi dir="ltr">`snet-appgw`</bdi> בטווח <bdi dir="ltr">`10.66.0.0/24`</bdi>. אין להכניס <bdi dir="ltr">VM</bdi> או <bdi dir="ltr">private endpoint</bdi> ל־<bdi dir="ltr">subnet</bdi> של <bdi dir="ltr">Gateway.</bdi> אם יצירת הרשת דורשת אישור נפרד, בטלו והציגו את השדות בלבד.
4. <bdi dir="ltr">Frontends: Public</bdi>, <bdi dir="ltr">Create new</bdi> <bdi dir="ltr">`pip-agw-demo06`</bdi> מסוג <bdi dir="ltr">Standard.</bdi> אין ליצור <bdi dir="ltr">IP</bdi> עצמאי לצורך סקירה בלבד.
5. <bdi dir="ltr">Backends:</bdi> הוסיפו <bdi dir="ltr">`pool-images`</bdi> ו־<bdi dir="ltr">`pool-videos`</bdi> עם **<bdi dir="ltr">Add backend pool without targets</bdi>**. אלה <bdi dir="ltr">pools</bdi> ריקים, לא שרתים בריאים.
6. <bdi dir="ltr">Configuration > Add routing rule:</bdi> שם <bdi dir="ltr">`route-demo06`</bdi>, <bdi dir="ltr">priority</bdi> <bdi dir="ltr">`100`</bdi>, <bdi dir="ltr">listener</bdi> <bdi dir="ltr">`listener-http`</bdi>, <bdi dir="ltr">public frontend</bdi>, <bdi dir="ltr">HTTP</bdi>, <bdi dir="ltr">port</bdi> <bdi dir="ltr">`80`</bdi>, <bdi dir="ltr">basic listener. Backend settings:</bdi> <bdi dir="ltr">`settings-http`</bdi>, <bdi dir="ltr">HTTP</bdi>, <bdi dir="ltr">port</bdi> <bdi dir="ltr">`80`</bdi>.
7. ב־<bdi dir="ltr">Backend targets</bdi> הציגו <bdi dir="ltr">Path-based routing: default pool</bdi> <bdi dir="ltr">`pool-images`</bdi>; כלל <bdi dir="ltr">`images`</bdi> ל־<bdi dir="ltr">`/images/*`</bdi> ול־<bdi dir="ltr">`pool-images`</bdi>; כלל <bdi dir="ltr">`videos`</bdi> ל־<bdi dir="ltr">`/videos/*`</bdi> ול־<bdi dir="ltr">`pool-videos`</bdi>, עם אותם <bdi dir="ltr">backend settings.</bdi> אם נדרש קודם לשמור כלל בסיסי בטיוטה, עשו זאת בתוך האשף בלבד.
8. הציגו <bdi dir="ltr">Multi-site listener: hostname</bdi> נדרש להבדיל אתרים; הוא אינו אותו מנגנון כמו <bdi dir="ltr">URL path.</bdi> חזרו להגדרת <bdi dir="ltr">Basic.</bdi>
9. סגרו את האשף. חלופה לקריאה בלבד: [סקירת התצורה הרשמית](https://learn.microsoft.com/azure/application-gateway/configuration-overview) והתרשים בשקופית <bdi dir="ltr">35.</bdi>

**תוצאה ואימות:** הדגמת תצורה בלבד; <bdi dir="ltr">pools</bdi> ריקים לא מפיקים דף <bdi dir="ltr">welcome</bdi>, והיעדר <bdi dir="ltr">Gateway</bdi> בקבוצה מאמת שלא חויבנו בפריסה. אין להציג <bdi dir="ltr">Backend health</bdi> כ־<bdi dir="ltr">Healthy.</bdi>

**תצפית הוראתית:** <bdi dir="ltr">Load Balancer</bdi> אינו מנתח <bdi dir="ltr">`/videos/`</bdi>; <bdi dir="ltr">Application Gateway</bdi> מנתח בקשת <bdi dir="ltr">HTTP.</bdi> בדיקת <bdi dir="ltr">path</bdi> אמיתית דורשת שרתי <bdi dir="ltr">HTTP</bdi>, תוכן מתאים, <bdi dir="ltr">NSGs</bdi>, <bdi dir="ltr">probe</bdi> תקין ונתיב לקוח.

**תקלות:** <bdi dir="ltr">subnet</bdi> לא ייעודי, <bdi dir="ltr">region</bdi> שונה ל־<bdi dir="ltr">public IP</bdi>, <bdi dir="ltr">priority</bdi> כפולה או <bdi dir="ltr">backend settings</bdi> שגויים. פריסה מלאה יכולה להימשך עשרות דקות ולהיכשל בשל <bdi dir="ltr">capacity/quota</bdi>; אין להתחיל אותה באמצע שיעור ללא תקציב.

**ניקוי:** השליכו טיוטות; אם נוצרו בטעות רשת/<bdi dir="ltr">IP</bdi> נפרדים של דמו זה בלבד, מחקו אחרי בדיקת <bdi dir="ltr">dependencies.</bdi> אל תמחקו את הרשתות של הדגמה <bdi dir="ltr">3.</bdi>

## <bdi dir="ltr">3. Network Watcher</bdi> — אבחון תקלה ב־<bdi dir="ltr">NSG</bdi>

**מטרה:** להוכיח ש־<bdi dir="ltr">route</bdi> תקין אינו מבטיח שה־<bdi dir="ltr">NSG</bdi> מאפשר תעבורה. זהו המסלול הפעיל המרכזי.

**דרישות:** <bdi dir="ltr">Contributor</bdi> בקבוצה והרשאות <bdi dir="ltr">Network Watcher</bdi>; שתי <bdi dir="ltr">Ubuntu VMs</bdi> מופעלות. <bdi dir="ltr">Next hop</bdi> ו־<bdi dir="ltr">IP flow verify</bdi> אינם דורשים את <bdi dir="ltr">Network Watcher extension</bdi>; <bdi dir="ltr">Connection troubleshoot</bdi> כן דורש הכנת <bdi dir="ltr">agent</bdi> ותנאי רשת. חשבונות חסומים לפריסה ישתמשו בסקירה בלבד, בלי לטעון שבוצעה בדיקה.

### הכנת סביבה בפורטל — לפני השיעור

1. ב־<bdi dir="ltr">`az104-demo06`</bdi> צרו <bdi dir="ltr">NSGs</bdi> בשם <bdi dir="ltr">`nsg-nm1`</bdi> ו־<bdi dir="ltr">`nsg-nm2`</bdi>, <bdi dir="ltr">West Europe.</bdi> בכל אחד הוסיפו <bdi dir="ltr">inbound rule:</bdi>
   - <span dir="ltr">Name `Allow-VNet-SSH-Inbound`, Priority `100`, Protocol TCP.</span>
   - <span dir="ltr">Source service tag `VirtualNetwork`, Source port `*`, Destination Any, Destination port `22`, Action Allow.</span>
2. צרו <bdi dir="ltr">`vnet-nm1`</bdi> עם <bdi dir="ltr">`10.10.0.0/16`</bdi>, <bdi dir="ltr">subnet</bdi> <bdi dir="ltr">`snet-nm1`</bdi> עם <bdi dir="ltr">`10.10.1.0/24`</bdi>; ב־<bdi dir="ltr">Subnet settings</bdi> שייכו <bdi dir="ltr">`nsg-nm1`</bdi>.
3. צרו <bdi dir="ltr">`vnet-nm2`</bdi> עם <bdi dir="ltr">`10.20.0.0/16`</bdi>, <bdi dir="ltr">subnet</bdi> <bdi dir="ltr">`snet-nm2`</bdi> עם <bdi dir="ltr">`10.20.1.0/24`</bdi>; שייכו <bdi dir="ltr">`nsg-nm2`</bdi>. אל תחברו רשת ארגונית עם טווח חופף.
4. ב־<bdi dir="ltr">`vnet-nm1`</bdi> > <bdi dir="ltr">Peerings > Add</bdi> הגדירו <bdi dir="ltr">peering</bdi> מקומי <bdi dir="ltr">`peer-nm1-to-nm2`</bdi> ומרוחק <bdi dir="ltr">`peer-nm2-to-nm1`</bdi>; בחרו <bdi dir="ltr">`vnet-nm2`</bdi>. הפעילו <bdi dir="ltr">Allow virtual network access</bdi> בשני הכיוונים; ללא <bdi dir="ltr">gateway transit.</bdi> בדקו שבשני <bdi dir="ltr">VNets</bdi> המצב <bdi dir="ltr">Connected.</bdi>
5. צרו <bdi dir="ltr">`vmnm1`</bdi> ו־<bdi dir="ltr">`vmnm2`</bdi> ב־<bdi dir="ltr">West Europe: Ubuntu Server 24.04 LTS</bdi>, <bdi dir="ltr">`Standard_B2s`</bdi> או גודל מאושר, <bdi dir="ltr">username</bdi> <bdi dir="ltr">`azureadmin`</bdi>, סיסמה ייחודית בהקלדה פרטית, <bdi dir="ltr">Standard SSD OS disk</bdi>, ללא <bdi dir="ltr">inbound public ports</bdi> וללא <bdi dir="ltr">Public IP.</bdi>
6. <bdi dir="ltr">Networking:</bdi> הראשונה ב־<bdi dir="ltr">`vnet-nm1/snet-nm1`</bdi>, השנייה ב־<bdi dir="ltr">`vnet-nm2/snet-nm2`</bdi>; <bdi dir="ltr">NIC NSG</bdi> = <bdi dir="ltr">None</bdi> כי <bdi dir="ltr">NSG</bdi> כבר משויך ל־<bdi dir="ltr">subnet.</bdi> אין צורך ב־<bdi dir="ltr">Bastion</bdi> לצורך <bdi dir="ltr">IP flow verify.</bdi>
7. בכל <bdi dir="ltr">VM</bdi> פתחו <bdi dir="ltr">Networking > Network settings > NIC > IP configurations > ipconfig1.</bdi> הגדירו <bdi dir="ltr">Static:</bdi> <bdi dir="ltr">`10.10.1.10`</bdi> לראשונה ו־<bdi dir="ltr">`10.20.1.10`</bdi> לשנייה. רשמו את שם ה־<bdi dir="ltr">NIC</bdi> בפועל; הפורטל עשוי לייצר שם שאינו <bdi dir="ltr">`nic-vmnm1`</bdi>.
8. <bdi dir="ltr">Network Watcher > Regions:</bdi> ודאו <bdi dir="ltr">Enabled</bdi> ב־<bdi dir="ltr">West Europe.</bdi> ייתכן שנוצר <bdi dir="ltr">Watcher</bdi> אוטומטי ב־<bdi dir="ltr">`NetworkWatcherRG`</bdi>; זהו משאב משותף ואין למחוק אותו בניקוי.
9. המתינו ל־<bdi dir="ltr">Running</bdi> בשתי המכונות. אין להניח <bdi dir="ltr">outbound internet</bdi> ברירת מחדל או התקנת <bdi dir="ltr">extension</bdi> מוצלחת ברשת פרטית.

### אבחון, שבירה ותיקון

1. <bdi dir="ltr">Network Watcher / Networking monitoring & management > Topology: Scope</bdi> למנוי, <bdi dir="ltr">`az104-demo06`</bdi>, <bdi dir="ltr">West Europe.</bdi> הרחיבו את שתי הרשתות והצביעו על <bdi dir="ltr">subnet NSGs</bdi>, <bdi dir="ltr">NICs</bdi> ו־<bdi dir="ltr">peering.</bdi>
2. <bdi dir="ltr">Next hop: VM</bdi> <bdi dir="ltr">`vmnm1`</bdi>, <bdi dir="ltr">Source</bdi> <bdi dir="ltr">`10.10.1.10`</bdi>, <bdi dir="ltr">Destination</bdi> <bdi dir="ltr">`10.20.1.10`</bdi>. הריצו. הצפי: <bdi dir="ltr">`VirtualNetworkPeering`</bdi>.
3. <bdi dir="ltr">IP flow verify: VM</bdi> <bdi dir="ltr">`vmnm1`</bdi>, ה־<bdi dir="ltr">NIC</bdi> שרשמתם, <bdi dir="ltr">TCP</bdi>, <bdi dir="ltr">Outbound</bdi>, <bdi dir="ltr">Local IP</bdi> <bdi dir="ltr">`10.10.1.10`</bdi>, <bdi dir="ltr">Local port</bdi> <bdi dir="ltr">`60000`</bdi>, <bdi dir="ltr">Remote IP</bdi> <bdi dir="ltr">`10.20.1.10`</bdi>, <bdi dir="ltr">Remote port</bdi> <bdi dir="ltr">`22`</bdi>. הריצו. הצפי: <bdi dir="ltr">Allowed</bdi>, לרוב <bdi dir="ltr">`AllowVnetOutBound`</bdi>.
4. ב־<bdi dir="ltr">`nsg-nm1`</bdi> > <bdi dir="ltr">Outbound security rules > Add</bdi> צרו:
   - <span dir="ltr">`Demo-Deny-SSH-To-VM2`, priority `200`, TCP, Deny.</span>
   - <span dir="ltr">Source IP `10.10.1.10/32`, Source ports `*`.</span>
   - <span dir="ltr">Destination IP `10.20.1.10/32`, Destination port `22`.</span>
5. המתינו להפצת הכלל והריצו שוב את אותו <bdi dir="ltr">IP flow verify.</bdi> הצפי: <bdi dir="ltr">Denied</bdi> עם שם כלל הדמו. <bdi dir="ltr">Next hop</bdi> אמור להישאר <bdi dir="ltr">`VirtualNetworkPeering`</bdi>.
6. <bdi dir="ltr">Effective security rules:</bdi> בחרו את <bdi dir="ltr">`vmnm1`</bdi> וה־<bdi dir="ltr">NIC</bdi> שלה. השוו <bdi dir="ltr">priority</bdi> <bdi dir="ltr">`200`</bdi> ל־<bdi dir="ltr">`65001`</bdi>; מספר נמוך גובר.
7. מחקו **רק** <bdi dir="ltr">`Demo-Deny-SSH-To-VM2`</bdi> והריצו שוב. הצפי: <bdi dir="ltr">Allowed.</bdi> אין שינוי ל־<bdi dir="ltr">peering</bdi> או לכללים אחרים.

### הרחבה אופציונלית: בדיקה חיה

אם מכינים <bdi dir="ltr">Connection troubleshoot</bdi> מראש, ספקו <bdi dir="ltr">outbound HTTPS</bdi> מפורש ומאושר להתקנת ה־<bdi dir="ltr">extension.</bdi> אפשרות מעבדה בתשלום: לכל <bdi dir="ltr">VNet</bdi> בנפרד צרו <bdi dir="ltr">NAT Gateway</bdi> (<bdi dir="ltr">`nat-nm1`</bdi>, <bdi dir="ltr">`nat-nm2`</bdi>) עם <bdi dir="ltr">Standard Static public IP</bdi> (<bdi dir="ltr">`pip-nat-nm1`</bdi>, <bdi dir="ltr">`pip-nat-nm2`</bdi>), וב־<bdi dir="ltr">NAT Gateway > Subnets</bdi> שייכו רק את ה־<bdi dir="ltr">subnet</bdi> המתאים. <bdi dir="ltr">NAT</bdi> אינו פותח כניסה מהאינטרנט. אין לשתף <bdi dir="ltr">NAT</bdi> אחד בין שני <bdi dir="ltr">VNets.</bdi> בדקו מדיניות <bdi dir="ltr">egress</bdi> ויעדי השירות לפי התיעוד, ולא רק <bdi dir="ltr">NSG.</bdi>

1. <bdi dir="ltr">VM > Extensions + applications > Add:</bdi> התקינו <bdi dir="ltr">Network Watcher Agent for Linux</bdi> בשתי המכונות ובדקו <bdi dir="ltr">Provisioning succeeded.</bdi>
2. <bdi dir="ltr">Connection troubleshoot: Source</bdi> <bdi dir="ltr">`vmnm1`</bdi>, <bdi dir="ltr">Destination IP</bdi> <bdi dir="ltr">`10.20.1.10`</bdi>, <bdi dir="ltr">TCP</bdi> <bdi dir="ltr">`22`</bdi>, בדיקות <bdi dir="ltr">Connectivity</bdi>, <bdi dir="ltr">NSG diagnostic</bdi> ו־<bdi dir="ltr">Next hop</bdi>; בלי <bdi dir="ltr">Port scanner.</bdi>
3. הריצו במצב הבריא, אחרי ה־<bdi dir="ltr">deny</bdi> ובסוף אחרי תיקון. בדיקה חיה צפויה לעבור <bdi dir="ltr">Reachable</bdi> → <bdi dir="ltr">Unreachable</bdi> → <bdi dir="ltr">Reachable</bdi>, אך רק אם <bdi dir="ltr">SSH</bdi> מאזין, <bdi dir="ltr">agents</bdi> מוכנים ונתיבי השירות תקינים. <bdi dir="ltr">IP flow verify</bdi> הוא סימולציה ואינו מוכיח ש־<bdi dir="ltr">sshd</bdi> פעיל.

**קבצים קיימים:** [<bdi dir="ltr">Checklist</bdi>](Demo-NetworkWatcher.md), [סקריפט ההקמה](Deploy-NetworkMonitor.ps1), [תבנית](main.bicep), [בדיקת <bdi dir="ltr">LB</bdi>](Lab.txt) נקראו לצורך המדריך, **לא להרצה כאן**. הסקריפט מקבל <bdi dir="ltr">`ResourceGroupName`</bdi> (ברירת מחדל <bdi dir="ltr">`network-monitor`</bdi>), <bdi dir="ltr">`Location`</bdi> (<bdi dir="ltr">`westeurope`</bdi>), <bdi dir="ltr">`TemplateFile`</bdi>, <bdi dir="ltr">`AdminUsername`</bdi>, <bdi dir="ltr">`AdminPassword`</bdi> מסוג <bdi dir="ltr">SecureString</bdi> ו־<bdi dir="ltr">`VmSize`</bdi> (<bdi dir="ltr">`Standard_B2s`</bdi>). הוא משתמש במנוי הפעיל ומתקין מודולים/<bdi dir="ltr">Bicep</bdi> חסרים; חייבים לאמת <bdi dir="ltr">context</bdi> מראש. אין להשתמש בסיסמת ברירת המחדל שבקובץ — ספקו סיסמה פרטית ב־<bdi dir="ltr">SecureString.</bdi> התבנית יוצרת את השמות והכתובות לעיל, <bdi dir="ltr">NICs</bdi> בשם <bdi dir="ltr">`nic-vmnm1/2`</bdi>, <bdi dir="ltr">peering</bdi> ו־<bdi dir="ltr">extensions</bdi>, אבל **לא** <bdi dir="ltr">NAT</bdi>, <bdi dir="ltr">Public IP</bdi> או <bdi dir="ltr">Bastion.</bdi> לכן הצלחת התקנת <bdi dir="ltr">extension</bdi> אינה מובטחת בלי <bdi dir="ltr">outbound</bdi> מאושר. ב־<bdi dir="ltr">Checklist</bdi> החליפו את <bdi dir="ltr">`network-monitor`</bdi> בשם הקבוצה שבחרתם. <bdi dir="ltr">`Lab.txt`</bdi> מיועד לשרת <bdi dir="ltr">HTTP</bdi> מאחורי <bdi dir="ltr">LB</bdi> חי; אינו מתאים לסביבה זו שאינה יוצרת <bdi dir="ltr">LB</bdi> או <bdi dir="ltr">HTTP.</bdi>

**תקלות נפוצות:** <bdi dir="ltr">VM deallocated</bdi>; בחירת <bdi dir="ltr">NIC/IP</bdi> לא נכונים; <bdi dir="ltr">peering Initiated</bdi>; <bdi dir="ltr">NSG</bdi> נוסף על <bdi dir="ltr">NIC</bdi>; <bdi dir="ltr">extension Failed</bdi> בגלל <bdi dir="ltr">egress</bdi>; <bdi dir="ltr">Topology</bdi> מתעדכן באיחור. ב־<bdi dir="ltr">Connection troubleshoot</bdi> השתמשו בבדיקה חדשה — חיבורים קיימים יכולים לשרוד שינוי <bdi dir="ltr">NSG.</bdi>

**תוצאה ואימות:** שמרו רק טבלת מצב <bdi dir="ltr">Allowed/Denied</bdi> ושם הכלל, בלי מידע רגיש. הוכחת הדמו היא השינוי ב־<bdi dir="ltr">NSG</bdi> והיעדר שינוי ב־<bdi dir="ltr">Next hop.</bdi>

**ניקוי:** הסירו קודם את כלל ה־<bdi dir="ltr">deny.</bdi> לאחר הדגמה <bdi dir="ltr">4</bdi> מחקו את <bdi dir="ltr">`az104-demo06`</bdi> רק אחרי סקירת רשימת המשאבים והתגים. ודאו שנמחקו גם <bdi dir="ltr">disks</bdi>, <bdi dir="ltr">NATs</bdi> ו־<bdi dir="ltr">IPs</bdi> אופציונליים; <bdi dir="ltr">Stop/deallocate</bdi> בלבד משאיר חיובי דיסקים ו־<bdi dir="ltr">NAT.</bdi> אל תמחקו <bdi dir="ltr">NetworkWatcherRG.</bdi>

## <bdi dir="ltr">4. Connection Monitor</bdi> ו־<bdi dir="ltr">VNet flow logs</bdi> — מסלול קריאה בלבד

**מטרה:** להבדיל בדיקה חד־פעמית ממדידה מתמשכת ולחבר <bdi dir="ltr">Flow logs</bdi> ל־<bdi dir="ltr">Traffic analytics</bdi>, בלי חיובי איסוף לא מבוקרים.

**דרישות ומשאבים:** סביבה מהכנת הדגמה <bdi dir="ltr">3</bdi>; <bdi dir="ltr">Reader</bdi> לסקירה, הרשאות יצירה אם רוצים לפתוח אשף. אין צורך ב־<bdi dir="ltr">Log Analytics</bdi> או <bdi dir="ltr">Storage</bdi> קיימים; אלה מוצגים כתלויות, לא נבחרים ממשאבי אחרים.

### צעדים

1. <bdi dir="ltr">Network Watcher > Connection monitor > Create.</bdi> שם טיוטה <bdi dir="ltr">`cm-demo06`</bdi>, <bdi dir="ltr">West Europe. Test group</bdi> <bdi dir="ltr">`ssh-peering`</bdi>, <bdi dir="ltr">source</bdi> <bdi dir="ltr">`vmnm1`</bdi>, <bdi dir="ltr">destination</bdi> <bdi dir="ltr">`10.20.1.10`</bdi>, <bdi dir="ltr">TCP port</bdi> <bdi dir="ltr">`22`</bdi>.
2. הציגו <bdi dir="ltr">test frequency</bdi> וספי <bdi dir="ltr">failed checks / round-trip time.</bdi> הציגו את <bdi dir="ltr">workspace output</bdi> הנדרש ואת תנאי <bdi dir="ltr">agent.</bdi> אין לשמור <bdi dir="ltr">monitor</bdi> כשאין <bdi dir="ltr">agents</bdi> מוכנים או <bdi dir="ltr">workspace</bdi> ייעודי.
3. בטלו את האשף. <bdi dir="ltr">Connection troubleshoot</bdi> אינו יוצר היסטוריית <bdi dir="ltr">monitor</bdi> באופן אוטומטי.
4. <bdi dir="ltr">Flow logs > Create:</bdi> בחרו **<bdi dir="ltr">Virtual network</bdi>**, <bdi dir="ltr">scope</bdi> <bdi dir="ltr">`vnet-nm1`</bdi>; שם לתכנון <bdi dir="ltr">`flow-demo06`</bdi>. אל תבחרו <bdi dir="ltr">NSG flow log</bdi> חדש: <bdi dir="ltr">Microsoft</bdi> הפסיקה לאפשר יצירתם, והם מיועדים לפרישה ב־<bdi dir="ltr">30</bdi> בספטמבר <bdi dir="ltr">2027.</bdi>
5. הציגו <bdi dir="ltr">Storage destination</bdi> ו־<bdi dir="ltr">retention.</bdi> כדי להפעיל באמת נדרש <bdi dir="ltr">Storage account</bdi> ייעודי מסוג נתמך ובאזור מתאים, למשל שם ייחודי <bdi dir="ltr">`az104d06flow`</bdi> עם סיומת ספרות ו־<bdi dir="ltr">Standard LRS.</bdi> הוא **לא** נוצר בהדגמה זו.
6. הציגו <bdi dir="ltr">Traffic analytics</bdi> וה־<bdi dir="ltr">Log Analytics workspace</bdi> הנדרש, כגון <bdi dir="ltr">`law-demo06`</bdi>. הסבירו ש־<bdi dir="ltr">raw flow records</bdi> וניתוחם אינם מופיעים מיד: נדרשת תעבורה, מחזורי איסוף/עיבוד והרשאות. אין הבטחה לגרף במהלך <bdi dir="ltr">12</bdi> דקות.
7. בטלו בלי <bdi dir="ltr">Create. Packet capture</bdi> נשאר אופציונלי ב־<bdi dir="ltr">Checklist:</bdi> אם משתמשים בו, מסננים רק תעבורת הדמו, עוצרים בזמן, ולא מורידים/משתפים <bdi dir="ltr">capture</bdi> המכיל תעבורת אחרים.

**תוצאה ואימות:** אין <bdi dir="ltr">monitors</bdi> או <bdi dir="ltr">flow logs</bdi> חדשים ואין חיובי <bdi dir="ltr">ingestion</bdi> שהופעלו בדמו. בקשו מהכיתה לזהות <bdi dir="ltr">agent</bdi>, <bdi dir="ltr">Storage</bdi> ו־<bdi dir="ltr">workspace</bdi> כתלויות שונות.

**תקלות:** האפשרות <bdi dir="ltr">NSG</bdi> חדשה אינה זמינה — זו פרישה, לא תקלה. אזור/<bdi dir="ltr">Storage</bdi> לא נתמכים, <bdi dir="ltr">workspace</bdi> שאינו נגיש או <bdi dir="ltr">agents</bdi> חסרים מונעים הפעלה אמיתית. חלופה: קריאת התרשימים והדוגמאות בתיעוד הרשמי, עם סימון ברור שאינן תוצאות המנוי.

**ניקוי:** השליכו טיוטות ובצעו את ניקוי הדגמה <bdi dir="ltr">3.</bdi> אם מישהו הפעיל <bdi dir="ltr">flow logging</bdi> מחוץ למסלול, כיבויו אינו מוחק <bdi dir="ltr">blobs</bdi> או נתוני <bdi dir="ltr">workspace</bdi>; מטפלים רק באחסון הדמו ובהתאם ל־<bdi dir="ltr">retention.</bdi>

## מקורות <bdi dir="ltr">Microsoft</bdi>

- [בחירת פתרון איזון עומס](https://learn.microsoft.com/azure/architecture/guide/technology-choices/load-balancing-overview)
- <span dir="ltr">[Load Balancer SKUs](https://learn.microsoft.com/azure/load-balancer/skus)</span>
- [<bdi dir="ltr">Application Gateway</bdi> בפורטל](https://learn.microsoft.com/azure/application-gateway/quick-create-portal)
- <span dir="ltr">[IP flow verify](https://learn.microsoft.com/azure/network-watcher/ip-flow-verify-overview)</span>
- <span dir="ltr">[Connection troubleshoot](https://learn.microsoft.com/azure/network-watcher/connection-troubleshoot-overview)</span>
- <span dir="ltr">[Connection Monitor](https://learn.microsoft.com/azure/network-watcher/connection-monitor-overview)</span>
- [פרישת <bdi dir="ltr">NSG flow logs</bdi>](https://learn.microsoft.com/azure/network-watcher/nsg-flow-logs-overview)
- <span dir="ltr">[VNet flow logs](https://learn.microsoft.com/azure/network-watcher/vnet-flow-logs-overview)</span>

</div>
