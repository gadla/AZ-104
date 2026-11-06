<div dir="rtl" align="right">

<h1><bdi dir="ltr">AZ-104</bdi> – תוכנית הכנה למסירת סדנת <bdi dir="ltr">Microsoft Azure Administrator</bdi></h1>

<h2>מטרת הריפו</h2>
<p>ריפו זה מרכז את חומרי ההכנה למסירת סדנת <code dir="ltr">AZ-104T00-A</code> בצורה חלקה ומקצועית:</p>
<ul>
  <li>תוכנית לימוד ל־14 יום בקצב של 2–3 שעות ביום</li>
  <li>קישורי לימוד רשמיים מ־<bdi dir="ltr">Microsoft Learn</bdi></li>
  <li>פרומפטים קבועים לשליחה אחרי כל מקטע, לצורך בדיקת עומק ממוקדת לפני המעבר לשלב הבא</li>
  <li>קבצי המצגות של הסדנה</li>
</ul>

<h2>מבנה מומלץ בריפו</h2>
<ul>
  <li><a href="./README.md"><code dir="ltr">README.md</code></a> – מסמך ההכנה הראשי (קובץ זה)</li>
  <li><a href="./slides/"><code dir="ltr">slides/</code></a> – כל קבצי ה־<bdi dir="ltr">PowerPoint</bdi> של הקורס</li>
  <li>(אופציונלי) <code dir="ltr">notes/</code> – סיכומי לימוד אישיים לכל יום</li>
</ul>

<h2>תוכנית הכנה ל־14 ימים (2–3 שעות ביום)</h2>
<p>הימים הם ימי הכנה של המדריך. תכנן 45 דקות ללימוד, 60 דקות לתרגיל בסיס ו־15 דקות להסבר בקול וסיכום. כשיש שעה נוספת, הקדש אותה להרחבה או לסגירת פערים. לאורך התוכנית השתמש בתרחיש אחד של העברת יישום פנימי מ־On-Prem ל־Azure.</p>
<p>לפני יום 1, הכן Tenant ו־Subscription למעבדות, הרשאות לתרגילי Entra ו־RBAC, אזור עם SKUs ו־quotas מתאימים ותקציב. במעבדות ארוכות הכן מראש VM, backend או נקודת שחזור לפי הצורך. בדוק את התוצאה עם זהות מעבדה, תעד ראיה והסר משאבים בתום השימוש. כאשר רישוי, הרשאות או זמני פריסה מגבילים תרגיל, השתמש בדמו מוכן או בנתוני דוגמה.</p>
<p>מיפוי לבחינה לפי מסגרת אפריל 2026. זהויות וממשל 20–25% (ימים 1–2), אחסון 15–20% (יום 7), מחשוב 20–25% (ימים 3 ו־8–10), רשת 15–20% (ימים 4–6), ניטור ותחזוקה 10–15% (ימים 11–12). ימים 13–14 משלבים את התחומים. משקלי הבחינה משמשים לבדיקת כיסוי, וחלוקת זמן ההדרכה נקבעת לפי הקהל והמעבדות. <a href="https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104#skills-measured-as-of-april-17-2026">מדריך הבחינה הרשמי</a> · <a href="https://learn.microsoft.com/en-us/training/courses/az-104t00">תוכנית הקורס הרשמית</a></p>
<p>מספרי המצגות מתייחסים לשמות הקבצים בתיקיית <a href="./slides/">slides</a>. המספרים שאחריהם הם מספרי שקופיות. משימות הבסיס וההרחבה הן תרגילי הכנה מוצעים, ובמקרים שבהם השקופיות נותנות סקירה בלבד יש להשלים מהתיעוד והמעבדות של Microsoft.</p>
<table dir="rtl">
  <thead>
    <tr><th>יום</th><th>נושא</th><th>מצגת ושקופיות</th><th>בסיס ותוצאה לבדיקה</th><th>הרחבה</th><th>מקור רשמי</th></tr>
  </thead>
  <tbody>
    <tr><td>1</td><td>זהויות וכניסה לסביבה</td><td><bdi dir="ltr">Introduction 5–11; 01 6–18, 20–22; 02 6–12</bdi></td><td>השווה AD DS ל־Entra ID. אמת Tenant ו־Subscription ב־Portal וב־CLI, צור משתמש וקבוצת בדיקה ובדוק חברות.</td><td>תרגל אורח B2B, שיוך רישיון ו־SSPR ב־Tenant מעבדה עם ההרשאות והרישוי המתאימים.</td><td><a href="https://learn.microsoft.com/training/paths/az-104-manage-identities-governance/">Microsoft Learn</a></td></tr>
    <tr><td>2</td><td>הרשאות, ממשל ועלויות</td><td><bdi dir="ltr">02 12–34, 40</bdi></td><td>הקצה Reader לקבוצה ב־Resource Group, אמת גישה בפועל, והחל Tag, Policy במצב Audit ו־Lock בסביבת בדיקה.</td><td>אבחן ירושת RBAC מול Deny של Policy. הגדר Budget עם התראה ובדוק המלצה ב־Azure Advisor.</td><td><a href="https://learn.microsoft.com/training/paths/az-104-manage-identities-governance/">Microsoft Learn</a></td></tr>
    <tr><td>3</td><td>כלי ניהול ופריסה חוזרת</td><td><bdi dir="ltr">03 4–20, 22–25</bdi></td><td>קרא משאב ב־Portal, ב־Azure CLI וב־Azure PowerShell. שנה פרמטר ב־Bicep, בצע what-if, פרוס ובדוק את התוצאה.</td><td>שנה ופרוס גם ARM JSON. ייצא תבנית או המר JSON ל־Bicep והשווה לפריסה המקורית.</td><td><a href="https://learn.microsoft.com/training/paths/az-104-manage-compute-resources/">Microsoft Learn</a></td></tr>
    <tr><td>4</td><td>רשת בסיסית ו־DNS</td><td><bdi dir="ltr">04 6–32</bdi></td><td>בנה VNet עם שני Subnets, הגדר NSG ו־ASG, בדוק Effective rules ופתור שם באמצעות Private DNS.</td><td>צור Public DNS zone ו־record set, הסבר delegation ובדוק מתי נדרש Public IP.</td><td><a href="https://learn.microsoft.com/training/paths/az-104-manage-virtual-networks/">Microsoft Learn</a></td></tr>
    <tr><td>5</td><td>קישוריות פרטית ואבחון נתיב</td><td><bdi dir="ltr">05 6–25; 06 22–28; 08 10–12</bdi></td><td>חבר VNets ב־Peering, הוסף UDR בסביבת בדיקה ואבחן תקלה לפי DNS, נתיב וכללי NSG עם Network Watcher.</td><td>השווה Service Endpoint ל־Private Endpoint מול Storage, כולל DNS. הדגם Bastion ל־VM ללא Public IP אם הסביבה מאפשרת.</td><td><a href="https://learn.microsoft.com/training/paths/az-104-manage-virtual-networks/">Microsoft Learn</a></td></tr>
    <tr><td>6</td><td>איזון עומסים</td><td><bdi dir="ltr">06 4–33</bdi></td><td>הגדר Standard Load Balancer פנימי או ציבורי מול Backends מוכנים. שבר Health Probe, זהה את התקלה ושחזר תעבורה.</td><td>השווה Internal ל־Public ו־Layer 4 ל־Application Gateway. Traffic Manager, Front Door ו־DDoS הם העשרה למסירה.</td><td><a href="https://learn.microsoft.com/training/paths/az-104-manage-virtual-networks/">Microsoft Learn</a></td></tr>
    <tr><td>7</td><td>אחסון וגישה לנתונים</td><td><bdi dir="ltr">07 6–47, 50</bdi></td><td>צור Blob container ו־Azure Files share, העתק קובץ עם AzCopy, בדוק SAS קצר־חיים ותרגל שחזור מגרסה או snapshot מתאים.</td><td>אבחן 403 לפי רשת והרשאה. תרגל Stored Access Policy ל־service SAS ובדוק Azure Files מבוסס זהות בסביבה מוכנה. השווה redundancy, encryption ו־object replication.</td><td><a href="https://learn.microsoft.com/training/paths/az-104-manage-storage/">Microsoft Learn</a></td></tr>
    <tr><td>8</td><td>VMs, דיסקים וזמינות</td><td><bdi dir="ltr">08 6–26</bdi></td><td>פרוס VM, חבר דיסק נתונים, אמת חיבור והסבר את ההבדל בין Availability Set ל־Availability Zone מול תרחיש On-Prem.</td><td>תרגל VMSS ושינוי גודל. תכנן העברה בין Resource Groups, Subscriptions או Regions והשווה SSE, encryption at host ו־ADE לפי התיעוד.</td><td><a href="https://learn.microsoft.com/training/paths/az-104-manage-compute-resources/">Microsoft Learn</a></td></tr>
    <tr><td>9</td><td>App Service</td><td><bdi dir="ltr">09 4–22, 35–36</bdi></td><td>פרוס Web App, זהה את ה־App Service plan, ואמת תגובת HTTP וגרסת אפליקציה.</td><td>תרגל slot ו־swap בתוכנית תומכת. בדוק scaling, גיבוי, custom domain ו־TLS, והסבר inbound access מול VNet Integration.</td><td><a href="https://learn.microsoft.com/training/paths/az-104-manage-compute-resources/">Microsoft Learn</a></td></tr>
    <tr><td>10</td><td>קונטיינרים</td><td><bdi dir="ltr">09 23–40</bdi></td><td>פרוס image מאושר ב־ACI וב־Container Apps דרך ה־Portal. אמת מצב ריצה ותגובה כשמוגדר ingress.</td><td>צור ACR, פרוס ממנו עם זהות והרשאה מתאימות ואבחן כשל image pull. השווה sizing ב־ACI לכללי scaling ב־Container Apps.</td><td><a href="https://learn.microsoft.com/training/paths/az-104-manage-compute-resources/">Microsoft Learn</a></td></tr>
    <tr><td>11</td><td>ניטור ותגובה לתקלה</td><td><bdi dir="ltr">11 5–28; 06 22–28</bdi></td><td>אסוף אותות ממשאב מעבדה, הבחֵן בין Metrics, Activity Log ו־Resource Logs, הרץ KQL ואמת הפעלת Alert ו־Action Group.</td><td>הוסף Alert Processing Rule, בחן Insights ל־VM, Storage ורשת, ובדוק קישוריות מתמשכת ב־Connection Monitor.</td><td><a href="https://learn.microsoft.com/training/paths/az-104-monitor-backup-resources/">Microsoft Learn</a></td></tr>
    <tr><td>12</td><td>גיבוי ושחזור</td><td><bdi dir="ltr">10 6–24</bdi></td><td>בחר vault לפי סוג workload, הגדר Backup Policy, אמת Recovery Point ושחזר פריט או VM בסביבת בדיקה.</td><td>הכן Azure Site Recovery מראש ותרגל Test Failover לרשת מבודדת. תעד תוצאות מול RPO/RTO ובדוק דוחות והתראות גיבוי.</td><td><a href="https://learn.microsoft.com/training/paths/az-104-monitor-backup-resources/">Microsoft Learn</a></td></tr>
    <tr><td>13</td><td>חזרה ראשונה ותרגיל משולב</td><td><bdi dir="ltr">Introduction 5–8; 02 30–34; 05 22–25; 07 45–47; 11 26–28</bdi></td><td>העבר פתיחה למשתתף On-Prem. פרוס רשת ואחסון ופתור כשל אחד באמצעות ראיות מ־RBAC, DNS או NSG.</td><td>שלב תקלה נוספת ממישור הנתונים או Azure Policy. הרץ את אותו תרחיש ללא הוראות צעד־אחר־צעד.</td><td><a href="https://microsoftlearning.github.io/AZ-104-MicrosoftAzureAdministrator/">מעבדות Microsoft</a></td></tr>
    <tr><td>14</td><td>חזרה ממוקדת והחלטת מוכנות</td><td><bdi dir="ltr">שקופיות לפי הפערים מיום 13; Conclusion 1–3</bdi></td><td>מסור מחדש שני קטעים שבהם התעכבת. בצע דמו מתוזמן, אמת תוצאה ורשום פער, מקור ותיקון לכל תקלה.</td><td>החלף משאב או הרשאה בזמן הדמו, התאושש והסבר את ההחלטה. בצע Practice Assessment ורכז פערים לפי תחום.</td><td><a href="https://learn.microsoft.com/credentials/certifications/azure-administrator/">הסמכה ותרגול</a></td></tr>
  </tbody>
</table>

<h2>השלמות והערות למדריך</h2>
<ul>
  <li>במצגת 09 שקופית 24 מציינת ACR כיעד. הוסף הדגמה מעשית של Registry והרשאת משיכה ביום 10. <a href="https://learn.microsoft.com/azure/container-registry/container-registry-intro">Azure Container Registry</a></li>
  <li>במצגת 07 שקופיות 4 ו־16 מציגות Blob versioning. תרגל שחזור בפועל והשלם Azure Files מבוסס זהות לצד השקופיות על shares ו־snapshots. <a href="https://learn.microsoft.com/azure/storage/blobs/versioning-overview">Blob versioning</a> · <a href="https://learn.microsoft.com/azure/storage/files/storage-files-active-directory-overview">Azure Files identity-based authentication</a></li>
  <li>במעבדת האיזון השתמש ב־Standard Load Balancer. הסבר את Basic בהקשר היסטורי אם הוא מופיע בחומר. ביום ה־VMs השתמש ב־encryption at host בתרגיל מתאים והתייחס ל־ADE בהקשר של סביבות קיימות והגירה. <a href="https://learn.microsoft.com/azure/load-balancer/load-balancer-overview">Load Balancer</a> · <a href="https://learn.microsoft.com/azure/virtual-machines/disk-encryption-migrate">מעבר מ־ADE</a></li>
  <li>במצגת 10 שקופית 20 נותנת מבוא ל־Site Recovery. הוסף תרגול failover מבודד והקפד להפריד בשיעור בין שחזור מנקודת גיבוי לבין הפעלת עומס עבודה באתר חלופי. <a href="https://learn.microsoft.com/azure/site-recovery/site-recovery-test-failover-to-azure">Test failover</a></li>
</ul>

<h2>קישורי עומק לפי מקטע ונושא (Microsoft Learn)</h2>
<p>להלן קישורי עומק מומלצים לכל נושא, כדי שתוכל להתכונן לרמת מסירה של סדנה מלאה:</p>

<h3>1) זהויות וממשל (<code dir="ltr">Identity + Governance</code>)</h3>
<ul>
  <li><a href="https://learn.microsoft.com/training/paths/az-104-manage-identities-governance/"><bdi dir="ltr">Learning Path: Manage identities and governance in Azure</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/role-based-access-control/overview"><bdi dir="ltr">RBAC overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/governance/management-groups/overview"><bdi dir="ltr">Management groups overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/governance/policy/overview"><bdi dir="ltr">Azure Policy overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-configure"><bdi dir="ltr">Microsoft Entra PIM configuration</bdi></a></li>
</ul>

<h3>2) תשתית כקוד (<code dir="ltr">ARM/Bicep</code>)</h3>
<ul>
  <li><a href="https://learn.microsoft.com/azure/azure-resource-manager/bicep/overview"><bdi dir="ltr">Bicep overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/azure-resource-manager/bicep/quickstart-create-bicep-use-visual-studio-code?tabs=CLI"><bdi dir="ltr">Bicep quickstart (VS Code + CLI)</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/azure-resource-manager/templates/overview"><bdi dir="ltr">ARM templates overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/azure-resource-manager/templates/deploy-cli"><bdi dir="ltr">Deploy ARM templates with Azure CLI</bdi></a></li>
</ul>

<h3>3) רשתות (<code dir="ltr">Networking</code>)</h3>
<ul>
  <li><a href="https://learn.microsoft.com/training/paths/az-104-manage-virtual-networks/"><bdi dir="ltr">Learning Path: Manage virtual networks in Azure</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/virtual-network/virtual-networks-overview"><bdi dir="ltr">Virtual Network overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/virtual-network/network-security-groups-overview"><bdi dir="ltr">NSG overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/virtual-network/virtual-networks-udr-overview"><bdi dir="ltr">User-defined routes (UDR) overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/private-link/private-endpoint-overview"><bdi dir="ltr">Private Endpoint overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/virtual-network/virtual-network-service-endpoints-overview"><bdi dir="ltr">Service Endpoints overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/ddos-protection/ddos-protection-overview"><bdi dir="ltr">Azure DDoS Protection overview</bdi></a></li>
</ul>

<h3>4) ניתוב ואיזון עומסים גלובלי/אזורי</h3>
<ul>
  <li><a href="https://learn.microsoft.com/azure/traffic-manager/traffic-manager-overview"><bdi dir="ltr">Traffic Manager overview (DNS-based global routing)</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/frontdoor/front-door-overview"><bdi dir="ltr">Azure Front Door overview (global HTTP edge)</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/application-gateway/overview"><bdi dir="ltr">Application Gateway overview (regional Layer 7)</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/load-balancer/load-balancer-overview"><bdi dir="ltr">Azure Load Balancer overview (regional Layer 4)</bdi></a></li>
</ul>

<h3>5) אחסון (<code dir="ltr">Storage</code>)</h3>
<ul>
  <li><a href="https://learn.microsoft.com/training/paths/az-104-manage-storage/"><bdi dir="ltr">Learning Path: Implement and manage storage in Azure</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/storage/common/storage-account-overview"><bdi dir="ltr">Storage account overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/storage/common/storage-redundancy"><bdi dir="ltr">Redundancy options (LRS/ZRS/GRS/GZRS)</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/storage/common/storage-sas-overview"><bdi dir="ltr">SAS overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/storage/common/storage-network-security"><bdi dir="ltr">Storage network security</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/storage/blobs/soft-delete-blob-overview"><bdi dir="ltr">Blob soft delete overview</bdi></a></li>
</ul>

<h3>6) מחשוב, אפליקציות וקונטיינרים (<code dir="ltr">Compute + PaaS + Containers</code>)</h3>
<ul>
  <li><a href="https://learn.microsoft.com/training/paths/az-104-manage-compute-resources/"><bdi dir="ltr">Learning Path: Deploy and manage Azure compute resources</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/virtual-machines/overview"><bdi dir="ltr">Azure Virtual Machines overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/virtual-machine-scale-sets/overview"><bdi dir="ltr">Virtual Machine Scale Sets overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/app-service/overview"><bdi dir="ltr">App Service overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/container-instances/container-instances-overview"><bdi dir="ltr">Azure Container Instances overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/container-apps/overview"><bdi dir="ltr">Azure Container Apps overview</bdi></a></li>
</ul>

<h3>7) ניטור, גיבוי והתאוששות מאסון (<code dir="ltr">Monitoring + Backup + DR</code>)</h3>
<ul>
  <li><a href="https://learn.microsoft.com/training/paths/az-104-monitor-backup-resources/"><bdi dir="ltr">Learning Path: Monitor and back up Azure resources</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/azure-monitor/overview"><bdi dir="ltr">Azure Monitor overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/azure-monitor/logs/log-analytics-workspace-overview"><bdi dir="ltr">Log Analytics workspace overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/azure-monitor/alerts/alerts-overview"><bdi dir="ltr">Azure alerts overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/azure-monitor/essentials/activity-log"><bdi dir="ltr">Azure Activity Log</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/backup/backup-overview"><bdi dir="ltr">Azure Backup overview</bdi></a></li>
  <li><a href="https://learn.microsoft.com/azure/site-recovery/site-recovery-overview"><bdi dir="ltr">Azure Site Recovery overview</bdi></a></li>
</ul>

<h3>8) מקורות רשמיים לבחינה ולמסלול הקורס</h3>
<ul>
  <li><a href="https://learn.microsoft.com/training/courses/az-104t00"><bdi dir="ltr">AZ-104T00 official course page</bdi></a></li>
  <li><a href="https://learn.microsoft.com/credentials/certifications/resources/study-guides/az-104"><bdi dir="ltr">AZ-104 study guide</bdi></a></li>
  <li><a href="https://learn.microsoft.com/credentials/certifications/azure-administrator/"><bdi dir="ltr">Azure Administrator certification page</bdi></a></li>
</ul>

<h2>נושאי חיזוק ממוקדים</h2>
<ol>
  <li><code dir="ltr">Traffic Manager</code> מול <code dir="ltr">Front Door</code> מול <code dir="ltr">Application Gateway</code></li>
  <li>הגנת <code dir="ltr">DDoS</code> (<bdi dir="ltr">L3/L4</bdi>)</li>
  <li><code dir="ltr">Private Endpoint</code> מול <code dir="ltr">Service Endpoint</code></li>
  <li><code dir="ltr">Azure Backup</code> מול <code dir="ltr">Azure Site Recovery</code> (<bdi dir="ltr">DR</bdi>)</li>
</ol>

<h2>פרומפט קבוע לשליחה אחרי כל מקטע</h2>
<pre dir="rtl" align="right">סיימתי את המקטע: &lt;שם המקטע&gt;.
<span dir="ltr">Please run a deep-dive oral check for AZ-104 instructor readiness.
Ask me 10 scenario-based questions, one at a time. Wait for my answer after each question:
 - 4 conceptual tradeoff questions
 - 4 troubleshooting questions
 - 2 "how would you teach this in class" questions
After each answer:
 - grade me (0-100)
 - tell me what was missing
 - give me a model answer in 4-6 bullets
At the end:
 - summarize my weak points
 - give me a 45-minute targeted improvement drill.</span></pre>

<h2>פרומפטים ייעודיים לפי נושא</h2>

<h3><bdi dir="ltr">Identity + Governance</bdi></h3>
<pre dir="rtl" align="right">סיימתי <bdi dir="ltr">Identity + Governance</bdi>.
<span dir="ltr">Run a deep-dive focused on RBAC scope design, PIM/JIT, Policy deny/audit effects, and management groups.</span></pre>

<h3><bdi dir="ltr">Networking</bdi></h3>
<pre dir="rtl" align="right">סיימתי <bdi dir="ltr">Networking</bdi>.
<span dir="ltr">Run a deep-dive focused on NSG vs UDR, peering, DNS, private connectivity, and Standard Load Balancer troubleshooting.</span></pre>

<h3><bdi dir="ltr">Storage</bdi></h3>
<pre dir="rtl" align="right">סיימתי <bdi dir="ltr">Storage</bdi>.
<span dir="ltr">Run a deep-dive focused on replication choices (LRS/ZRS/GRS), secure data access (SAS, firewall, endpoints), and data protection features.</span></pre>

<h3><bdi dir="ltr">Compute + PaaS + Containers</bdi></h3>
<pre dir="rtl" align="right">סיימתי <bdi dir="ltr">Compute + PaaS + Containers</bdi>.
<span dir="ltr">Run a deep-dive focused on VM operations, App Service vs ACI vs Container Apps, and scaling decisions.</span></pre>

<h3><bdi dir="ltr">Monitoring + Backup + DR</bdi></h3>
<pre dir="rtl" align="right">סיימתי <bdi dir="ltr">Monitoring + Backup + DR</bdi>.
<span dir="ltr">Run a deep-dive focused on Monitor/Log Analytics investigation flow, alert strategy, Backup vs ASR decision framework, and DR runbook thinking.</span></pre>

<h3><bdi dir="ltr">Full workshop rehearsal</bdi></h3>
<pre dir="rtl" align="right">סיימתי חזרה מלאה.
<span dir="ltr">Simulate a full instructor readiness panel for AZ-104:
 - ask cross-domain scenario questions
 - include "student asks a hard question" simulations
 - evaluate clarity, correctness, and teaching flow
 - provide a final go/no-go readiness verdict.</span></pre>

<h2>מוכנות למסירה (<bdi dir="ltr">Definition of Done</bdi>)</h2>
<ul>
  <li>ציון של 80% ומעלה במבחני תרחישים בכל דומיין</li>
  <li>יכולת להסביר בחירות ארכיטקטוניות בדקה לתרחיש</li>
  <li>מסירה מתוזמנת של מקטעי מפתח, עם תוצאה מאומתת לכל דמו שנבחר</li>
  <li>סגירת פערים מתועדת אחרי כל חזרה</li>
</ul>

</div>
