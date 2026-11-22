<div dir="rtl" align="right">

# <bdi dir="ltr">Module 03</bdi> — מדריך הדגמות: <bdi dir="ltr">Administer Azure Resources</bdi>

מצגת: [<bdi dir="ltr">AZ-104T00A-ENU-PowerPoint_03.pptx</bdi>](./AZ-104T00A-ENU-PowerPoint_03.pptx), <bdi dir="ltr">26</bdi> שקופיות.
זהו מדריך נלווה והדגמות נוספות; [<bdi dir="ltr">Demo.ps1</bdi> הקיים](./Demo.ps1) וקבצי התבניות נשארים ללא שינוי. הדגמות הכלים בשקופית <bdi dir="ltr">9</bdi> והתבניות בשקופית <bdi dir="ltr">17</bdi> הן עוגני השיעור. ההדגמה הנוספת משתמשת ב־<bdi dir="ltr">Storage</bdi> ריק עם <bdi dir="ltr">Standard_LRS</bdi>; היא אינה מחליפה את <bdi dir="ltr">Lab 03</bdi> או את קבצי הדמו הקיימים.

## תוכנית ובטיחות

| הדגמה | שקופיות | זמן | משאבים |
|---:|---:|---:|---:|
| <bdi dir="ltr">1. Portal</bdi>, <bdi dir="ltr">Cloud Shell</bdi> ו־<bdi dir="ltr">Copilot</bdi> | <span dir="ltr">6–10, 24</span> | <bdi dir="ltr">10</bdi>–<bdi dir="ltr">15</bdi> דקות | ללא פריסה; <bdi dir="ltr">Copilot</bdi> אופציונלי |
| <bdi dir="ltr">2.</bdi> אותו <bdi dir="ltr">RG</bdi> ב־<bdi dir="ltr">PowerShell</bdi> וב־<bdi dir="ltr">CLI</bdi> | <span dir="ltr">7–9, 23–26</span> | <bdi dir="ltr">15</bdi> דקות | <bdi dir="ltr">RG</bdi> ייעודי בלבד |
| <bdi dir="ltr">3. ARM JSON</bdi> מול <bdi dir="ltr">Bicep</bdi> | <span dir="ltr">12–17, 20–21</span> | <bdi dir="ltr">20</bdi>–<bdi dir="ltr">30</bdi> דקות | שני <bdi dir="ltr">Storage accounts</bdi> ריקים |
| <bdi dir="ltr">4. Template</bdi>, <bdi dir="ltr">Export</bdi> ו־<bdi dir="ltr">Quickstart</bdi> | <span dir="ltr">13–17, 20–21</span> | <bdi dir="ltr">15</bdi> דקות | קריאה במשאבי הדמו בלבד |

- השתמשו במינוי מעבדה פעיל שסופק מראש, לא בהנחה שקיים <bdi dir="ltr">Sandbox</bdi> חינמי. אין לפרוס דבר בעת קריאת המדריך; פקודות הפריסה מיועדות לביצוע מאוחר יותר בכיתה.
- ב־<bdi dir="ltr">Portal ></bdi> **<bdi dir="ltr">Settings > Directories + subscriptions</bdi>** בדקו <bdi dir="ltr">Tenant</bdi> ומינוי. ל־<bdi dir="ltr">PowerShell</bdi> ול־<bdi dir="ltr">CLI</bdi> הקשרים נפרדים; יש לאשר את שניהם לפני פקודת כתיבה.
- מנהל המעבדה יספק הרשאות <bdi dir="ltr">Contributor</bdi> על <bdi dir="ltr">RG</bdi> ייעודי, והרשאת יצירת <bdi dir="ltr">RG</bdi> אם המרצה יוצר אותו. אין להוסיף <bdi dir="ltr">Owner</bdi> במינוי. <bdi dir="ltr">Provider</bdi> של <bdi dir="ltr">Storage</bdi> צריך להיות רשום מראש; רישום <bdi dir="ltr">Provider</bdi> במינוי הוא משימת מנהל המעבדה, לא הדגמה.
- שמות: <bdi dir="ltr">`rg-az104-m03-guide`</bdi>, <bdi dir="ltr">Tag</bdi> <bdi dir="ltr">`DemoOwner=AZ104-M03`</bdi>. חשבונות <bdi dir="ltr">Storage</bdi> יקבלו סיומת אקראית, באותיות קטנות וספרות, כדי להימנע מהתנגשות גלובלית.
- <bdi dir="ltr">Storage</bdi> ריק זול יחסית אך אינו הבטחה לאפס עלות. אין להעלות נתונים, להציג <bdi dir="ltr">Access keys</bdi>, ליצור <bdi dir="ltr">SAS</bdi> או לפתוח <bdi dir="ltr">Public blob access.</bdi> התבניות כאן הן דוגמאות בסיסיות, לא תבניות <bdi dir="ltr">Production</bdi> מוקשחות.

## הקבצים הקיימים — לקרוא לפני שמריצים

| קובץ | התנהגות בפועל |
|---:|---:|
| <span dir="ltr">[Demo.ps1](./Demo.ps1)</span> | כניסה באמצעות <bdi dir="ltr">Device authentication</bdi>; <bdi dir="ltr">RG</bdi> קבוע <bdi dir="ltr">`rg-az104-demo`</bdi> שנוצר ב־<bdi dir="ltr">`israelcentral`</bdi> אם חסר; ארבע פריסות; מחיקת חשבון <bdi dir="ltr">Storage</bdi> באמצע |
| <span dir="ltr">[Storage.json](./Storage.json)</span> | <bdi dir="ltr">API</bdi> <bdi dir="ltr">`2023-05-01`</bdi>, <bdi dir="ltr">StorageV2</bdi>, <bdi dir="ltr">Standard_LRS</bdi>; פרמטר <bdi dir="ltr">`storageAccountName`</bdi> עם <bdi dir="ltr">Default</bdi> <bdi dir="ltr">`az104demops12345`</bdi>; <bdi dir="ltr">Location</bdi> מקובע ב־<bdi dir="ltr">Variables</bdi> ל־<bdi dir="ltr">`israelcentral`</bdi> |
| <span dir="ltr">[Storage.bicep](./Storage.bicep)</span> | אותו <bdi dir="ltr">API</bdi>, <bdi dir="ltr">Kind</bdi> ו־<bdi dir="ltr">SKU</bdi>; פרמטר חובה <bdi dir="ltr">`storageAccountName`</bdi>; <bdi dir="ltr">Location</bdi> הוא <bdi dir="ltr">`resourceGroup().location`</bdi> |

ב־<bdi dir="ltr">`Demo.ps1`</bdi> השמות הם <bdi dir="ltr">`az104demops12345`</bdi>, <bdi dir="ltr">`az104demobicepps12345`</bdi>, <bdi dir="ltr">`az104demojson12345`</bdi>, <bdi dir="ltr">`az104demobicep12345`</bdi>. הסקריפט מוחק ב־<bdi dir="ltr">Force</bdi> את הראשון לאחר פריסת <bdi dir="ltr">JSON</bdi>, ולא מוחק את שלושת האחרים בסיום. הוא משתמש בשמות גלובליים קבועים, אינו מאשר <bdi dir="ltr">Context</bdi> של <bdi dir="ltr">CLI</bdi>, ואינו מוודא שה־<bdi dir="ltr">RG</bdi> הקיים שייך לדמו.

**לכן אין להריץ את <bdi dir="ltr">`Demo.ps1`</bdi> בשלמותו בכיתה.** הציגו אותו בקריאה בלבד, והריצו את הפקודות הממוקדות להלן עם <bdi dir="ltr">RG</bdi> חדש ושמות ייחודיים. אין לו <bdi dir="ltr">Switch</bdi> לשינוי <bdi dir="ltr">RG</bdi> או <bdi dir="ltr">Region</bdi>; ל־<bdi dir="ltr">Storage.json</bdi> אין פרמטר <bdi dir="ltr">Location.</bdi> אין להמציא לו אפשרויות שאינן קיימות.

## הדגמה <bdi dir="ltr">1</bdi> — <bdi dir="ltr">Portal</bdi> ו־<bdi dir="ltr">Cloud Shell</bdi> ללא שינוי תשתית

**מטרה:** להראות את שכבת הניהול המשותפת ולהכיר את סביבת הפקודות.

**דרישות:** חשבון מעבדה עם <bdi dir="ltr">Reader</bdi> לפחות; <bdi dir="ltr">Cloud Shell</bdi> זמין או מסוף מעבדה עם <bdi dir="ltr">Az</bdi> ו־<bdi dir="ltr">Azure CLI</bdi> מותקנים. <bdi dir="ltr">`Microsoft.CloudShell`</bdi> רשום מראש אם משתמשים בשירות.

### צעדים

1. ב־<bdi dir="ltr">Azure portal</bdi> פתחו **<bdi dir="ltr">All services</bdi>**, חפשו **<bdi dir="ltr">Resource groups</bdi>** והוסיפו ל־<bdi dir="ltr">Favorites.</bdi> ב־**<bdi dir="ltr">Settings > Appearance + startup views</bdi>** הדגימו שינוי <bdi dir="ltr">Theme</bdi> אישי. אין ליצור <bdi dir="ltr">Dashboard</bdi> משותף או לפרסם אותו.
2. לחצו על סמל **<bdi dir="ltr">Cloud Shell</bdi>** בשורת הכלים ובחרו **<bdi dir="ltr">PowerShell</bdi>**. באתחול ראשון העדיפו **<bdi dir="ltr">No storage account required</bdi>** / <bdi dir="ltr">Ephemeral</bdi> אם מוצע. בחרו את מינוי המעבדה.
3. הסבירו: <bdi dir="ltr">Ephemeral</bdi> אינו דורש <bdi dir="ltr">Storage account</bdi>, וקבצים בו אובדים בסיום <bdi dir="ltr">Session.</bdi> אם המעבדה משתמשת ב־<bdi dir="ltr">Persistent storage</bdi> שסופק מראש, אין למחוק אותו בסיום. אם <bdi dir="ltr">Cloud Shell</bdi> חסום, השתמשו במסוף המעבדה ולא משנים <bdi dir="ltr">Policy</bdi> במינוי.
4. הריצו פקודות קריאה:

   <div dir="ltr" align="right">

   ```powershell
   Get-Module -ListAvailable Az.Accounts
   Get-Command Get-AzResourceGroup
   Get-Help Get-AzResourceGroup -Examples
   az group list --help
   ```

   </div>


5. אופציונלי: אם **<bdi dir="ltr">Copilot in Azure</bdi>** נגיש ומאושר, שאלו שאלה כללית בלבד: <bdi dir="ltr">`Explain the difference between Azure Resource Manager JSON and Bicep. Do not execute any actions.`</bdi> אין להדביק קוד ארגוני, <bdi dir="ltr">Tenant data</bdi> או <bdi dir="ltr">Secrets</bdi> ואין לאשר הצעות פריסה.
6. אם <bdi dir="ltr">Copilot</bdi> אינו זמין, הציגו את דף <bdi dir="ltr">Capabilities</bdi> הרשמי והמשיכו. זמינותו תלויה במינוי, סביבת הענן והרשאות; הוא אינו תנאי לביצוע המודול.

**תוצאה ואימות:** מתקבלים <bdi dir="ltr">Help</bdi> לפקודות <bdi dir="ltr">PowerShell</bdi> ו־<bdi dir="ltr">CLI</bdi> והמשתתפים מזהים את שני הממשקים. <bdi dir="ltr">Copilot</bdi>, אם זמין, מספק הסבר ולא מבצע פעולה.

**נקודת הוראה:** כל הכלים פונים ל־<bdi dir="ltr">Azure Resource Manager</bdi>; התחברות לכלי אינה מעניקה הרשאות נוספות. <bdi dir="ltr">Cloud Shell</bdi> אינו <bdi dir="ltr">VM</bdi> של המשתמש ואין לשמור בו סודות.

**תקלות נפוצות:** <bdi dir="ltr">Module/CLI</bdi> חסר במסוף מקומי — השתמשו במסוף שסופק או <bdi dir="ltr">Cloud Shell. Provider</bdi> חסר — פנו למנהל המעבדה, בלי לרשום <bdi dir="ltr">Providers</bdi> נוספים לצורך שיעור.

**ניקוי:** שחזרו <bdi dir="ltr">Theme</bdi> אישי אם רוצים. סגרו <bdi dir="ltr">Copilot.</bdi> אין למחוק <bdi dir="ltr">Storage</bdi> של <bdi dir="ltr">Cloud Shell</bdi> שסופק מראש; קבצי <bdi dir="ltr">Ephemeral</bdi> נעלמים עם סיום <bdi dir="ltr">Session.</bdi>

## הדגמה <bdi dir="ltr">2</bdi> — <bdi dir="ltr">Resource group</bdi> אחד דרך שני כלים

**מטרה:** לראות אותו <bdi dir="ltr">Resource ID</bdi> ו־<bdi dir="ltr">Tag</bdi> בשני כלים ולהבין <bdi dir="ltr">Context</bdi> עצמאי.

**דרישות:** <bdi dir="ltr">PowerShell 7</bdi> עם <bdi dir="ltr">Az</bdi> ו־<bdi dir="ltr">Azure CLI</bdi> באותו מסוף; הרשאת יצירת <bdi dir="ltr">RG</bdi> או <bdi dir="ltr">RG</bdi> חדש שהמנהל הכין **אך לא <bdi dir="ltr">RG</bdi> משותף**. הדוגמה להלן מניחה שה־<bdi dir="ltr">RG</bdi> עדיין אינו קיים.

### צעדים

1. ב־<bdi dir="ltr">PowerShell</bdi> מקומי בלבד התחברו. <bdi dir="ltr">Cloud Shell</bdi> כבר מזוהה; אין צורך לבצע בו <bdi dir="ltr">`Connect-AzAccount`</bdi> מחדש. החליפו את שני ה־<bdi dir="ltr">Placeholders</bdi> במזהי **המעבדה** שאושרו למרצה; אין לפרסם אותם.

   <div dir="ltr" align="right">

   ```powershell
   # Local lab terminal only:
   Connect-AzAccount
   az login

   $tenantId = "<LAB-TENANT-ID>"
   $subscriptionId = "<LAB-SUBSCRIPTION-ID>"
   Set-AzContext -Tenant $tenantId -SubscriptionId $subscriptionId
   az account set --subscription $subscriptionId
   Get-AzContext | Select-Object Tenant, Subscription
   az account show --query "{tenant:tenantId,subscription:id,name:name}" -o table
   ```

   </div>


   בדקו באופן פרטי ששני הכלים ב־<bdi dir="ltr">Tenant</bdi> ובמינוי הנכונים. אם <bdi dir="ltr">CLI</bdi> מחובר ל־<bdi dir="ltr">Tenant</bdi> אחר, בצעו במסוף המקומי <bdi dir="ltr">`az login --tenant $tenantId`</bdi>, בחרו שוב מינוי ואמתו. אין להמשיך כאשר ההקשרים שונים.

2. בדקו שם פנוי וצורו <bdi dir="ltr">RG</bdi>; <bdi dir="ltr">`israelcentral`</bdi> נבחר כדי להתאים לתבנית <bdi dir="ltr">JSON</bdi> הקיימת. אם מיקום זה חסום במעבדה, עוצרים את מסלול <bdi dir="ltr">JSON</bdi>; אין לשנות <bdi dir="ltr">Region</bdi> בפרמטר שאינו קיים.

   <div dir="ltr" align="right">

   ```powershell
   $rg = "rg-az104-m03-guide"
   if (Get-AzResourceGroup -Name $rg -ErrorAction SilentlyContinue) {
       throw "The demo RG already exists. Choose a fresh demo-only name."
   }
   New-AzResourceGroup -Name $rg -Location "israelcentral" `
       -Tag @{ DemoOwner = "AZ104-M03" }
   Get-AzResourceGroup -Name $rg |
       Select-Object ResourceGroupName, Location, ResourceId, Tags
   az group show --name $rg --query "{name:name,location:location,id:id,tags:tags}" -o json
   ```

   </div>


3. ב־<bdi dir="ltr">CLI</bdi> הוסיפו <bdi dir="ltr">Tag</bdi> **בלי למחוק את הקיים**:

   <div dir="ltr" align="right">

   ```powershell
   az group update --name $rg --set tags.ToolDemo=CLI `
       --query "{name:name,tags:tags}" -o json
   Get-AzResourceGroup -Name $rg | Select-Object ResourceGroupName, Tags
   ```

   </div>


4. בפורטל חפשו את <bdi dir="ltr">RG</bdi> הדמו > **<bdi dir="ltr">Tags</bdi>**. ודאו ששני <bdi dir="ltr">Tags</bdi> קיימים: <bdi dir="ltr">`DemoOwner`</bdi> ו־<bdi dir="ltr">`ToolDemo`</bdi>.

**תוצאה ואימות:** <bdi dir="ltr">Resource ID</bdi> זהה בשלוש התצוגות ו־<bdi dir="ltr">Tag</bdi> שנכתב ב־<bdi dir="ltr">CLI</bdi> מופיע ב־<bdi dir="ltr">PowerShell</bdi> ובפורטל. אין <bdi dir="ltr">Compute.</bdi>

**נקודת הוראה:** <bdi dir="ltr">PowerShell</bdi> מחזיר <bdi dir="ltr">Objects</bdi> ו־<bdi dir="ltr">CLI</bdi> יכול להחזיר <bdi dir="ltr">JSON</bdi>; אלה דרכי תצוגה של אותו <bdi dir="ltr">Resource Manager.</bdi>

**תקלות נפוצות:** <bdi dir="ltr">`AuthorizationFailed`</bdi> — בדקו <bdi dir="ltr">Scope</bdi> והקשרים ולא מוסיפים <bdi dir="ltr">Owner.</bdi> <bdi dir="ltr">`LocationNotAvailableForResourceType`</bdi> או <bdi dir="ltr">Policy</bdi> — השתמשו באזור המאושר למסלול <bdi dir="ltr">Bicep</bdi> בלבד, ב־<bdi dir="ltr">RG</bdi> חדש; <bdi dir="ltr">JSON</bdi> עדיין מצביע ל־<bdi dir="ltr">Israel Central.</bdi>

**ניקוי:** אם ממשיכים, משאירים את <bdi dir="ltr">RG.</bdi> אם עוצרים, בדקו בפורטל שאין בו משאבים זרים, ואז <bdi dir="ltr">`Remove-AzResourceGroup -Name $rg`</bdi> עם אישור; אין להשתמש ב־<bdi dir="ltr">Force</bdi> בניקוי.

## הדגמה <bdi dir="ltr">3</bdi> — <bdi dir="ltr">ARM JSON</bdi> ו־<bdi dir="ltr">Bicep</bdi>, <bdi dir="ltr">Validate</bdi> לפני <bdi dir="ltr">Create</bdi>

**מטרה:** לפרוס שני חשבונות ריקים, להבין פרמטרים ומיקום, ולראות ש־<bdi dir="ltr">Bicep</bdi> מתורגם ל־<bdi dir="ltr">ARM.</bdi>

**דרישות:** הדגמה <bdi dir="ltr">2</bdi> הושלמה באותו מסוף; <bdi dir="ltr">Contributor</bdi> ב־<bdi dir="ltr">RG</bdi>, <bdi dir="ltr">Storage provider</bdi> רשום, <bdi dir="ltr">Israel Central</bdi> מאושר למסלול <bdi dir="ltr">JSON</bdi>; <bdi dir="ltr">Bicep CLI</bdi> זמין לפריסת <bdi dir="ltr">Bicep.</bdi> בדקו מראש <bdi dir="ltr">`bicep --version`</bdi> ו־<bdi dir="ltr">`az bicep version`</bdi>; אם חסר, השתמשו במעבדה מוכנה או הציגו <bdi dir="ltr">Bicep</bdi> בקריאה בלבד.

### צעדים

1. במסוף <bdi dir="ltr">Windows</bdi> מקומי:

   <div dir="ltr" align="right">

   ```powershell
   Set-Location "C:\Repo\AZ-104\slides\Module 03 - Administer Azure Resources"
   Get-Item .\Storage.json, .\Storage.bicep
   ```

   </div>


   ב־<bdi dir="ltr">Cloud Shell</bdi> במקום <bdi dir="ltr">`Set-Location`</bdi> זה, העלו דרך **<bdi dir="ltr">Upload/Download > Upload</bdi>** את שני הקבצים בלבד, עברו לתיקייה שאליה הועלו ובדקו אותם עם <bdi dir="ltr">`Get-Item`</bdi>. אין להעלות <bdi dir="ltr">`Demo.ps1`</bdi> ולהריץ אותו. הנתיבים היחסיים בהמשך מתאימים ל־<bdi dir="ltr">PowerShell</bdi> גם ב־<bdi dir="ltr">Cloud Shell.</bdi>

2. בחרו שני שמות גלובליים ייחודיים, ובדקו זמינות דרך <bdi dir="ltr">CLI:</bdi>

   <div dir="ltr" align="right">

   ```powershell
   $suffix = [guid]::NewGuid().ToString("N").Substring(0,8)
   $jsonName = "az104m03j$suffix"
   $bicepName = "az104m03b$suffix"
   az storage account check-name --name $jsonName -o json
   az storage account check-name --name $bicepName -o json
   ```

   </div>


   המשיכו רק אם <bdi dir="ltr">`nameAvailable=true`</bdi> לשניהם. אם לא, צרו סיומת חדשה ובדקו מחדש. רשמו את השמות למטרת ניקוי בלבד; הם אינם <bdi dir="ltr">Secrets.</bdi>

3. ב־<bdi dir="ltr">PowerShell</bdi> בצעו <bdi dir="ltr">Validate</bdi> ו־<bdi dir="ltr">What-if</bdi> ל־<bdi dir="ltr">JSON:</bdi>

   <div dir="ltr" align="right">

   ```powershell
   Test-AzResourceGroupDeployment -ResourceGroupName $rg `
       -TemplateFile .\Storage.json -storageAccountName $jsonName
   New-AzResourceGroupDeployment -ResourceGroupName $rg `
       -TemplateFile .\Storage.json -storageAccountName $jsonName `
       -Mode Incremental -WhatIf
   ```

   </div>


   <bdi dir="ltr">Validate</bdi> ללא שגיאות יכול לא להציג פלט. <bdi dir="ltr">What-if</bdi> אמור להציג <bdi dir="ltr">Create</bdi> לחשבון הדמו בלבד. אם מופיעים <bdi dir="ltr">Delete</bdi> או שינוי למשאב לא צפוי, עצרו.

4. לאחר אישור המרצה, פרסו **רק** את <bdi dir="ltr">JSON:</bdi>

   <div dir="ltr" align="right">

   ```powershell
   New-AzResourceGroupDeployment -Name "m03-json-demo" `
       -ResourceGroupName $rg -TemplateFile .\Storage.json `
       -storageAccountName $jsonName -Mode Incremental
   Get-AzStorageAccount -ResourceGroupName $rg -Name $jsonName |
       Select-Object StorageAccountName, Location, Kind, ProvisioningState
   ```

   </div>


5. במסוף <bdi dir="ltr">PowerShell</bdi> עצמו, <bdi dir="ltr">CLI</bdi> אינו <bdi dir="ltr">Bash:</bdi> אפשר להשתמש ב־<bdi dir="ltr">Backtick</bdi> להמשך שורה. <bdi dir="ltr">Validate</bdi> ו־<bdi dir="ltr">What-if</bdi> ל־<bdi dir="ltr">Bicep:</bdi>

   <div dir="ltr" align="right">

   ```powershell
   az deployment group validate --resource-group $rg `
       --template-file .\Storage.bicep `
       --parameters "storageAccountName=$bicepName"
   az deployment group what-if --resource-group $rg `
       --template-file .\Storage.bicep `
       --parameters "storageAccountName=$bicepName" --mode Incremental
   ```

   </div>


6. אחרי בדיקת הפלט, פרסו את <bdi dir="ltr">Bicep:</bdi>

   <div dir="ltr" align="right">

   ```powershell
   az deployment group create --name "m03-bicep-demo" `
       --resource-group $rg --template-file .\Storage.bicep `
       --parameters "storageAccountName=$bicepName" --mode Incremental
   az storage account show --resource-group $rg --name $bicepName `
       --query "{name:name,location:location,kind:kind,sku:sku.name,state:provisioningState}" -o json
   ```

   </div>


7. בפורטל **<bdi dir="ltr">RG > Deployments</bdi>** פתחו את שתי הפריסות > **<bdi dir="ltr">Deployment details</bdi>**. ודאו <bdi dir="ltr">Succeeded</bdi>, שם החשבון והאזור. <bdi dir="ltr">`Storage.bicep`</bdi> יורש את מיקום <bdi dir="ltr">RG</bdi>; <bdi dir="ltr">JSON</bdi> אינו יורש אותו, אלא מקובע ל־<bdi dir="ltr">`israelcentral`</bdi>.
8. אופציונלי ללא פריסה נוספת: הציגו את <bdi dir="ltr">JSON</bdi> המתורגם מ־<bdi dir="ltr">Bicep</bdi> במסוף:

   <div dir="ltr" align="right">

   ```powershell
   bicep build .\Storage.bicep --stdout
   ```

   </div>


   מצאו <bdi dir="ltr">Parameters</bdi> ו־<bdi dir="ltr">Resources.</bdi> אין צורך לייצר קובץ נוסף או לשנות את קבצי הריפו.

**תוצאה ואימות:** שני חשבונות <bdi dir="ltr">StorageV2</bdi>, <bdi dir="ltr">Standard_LRS</bdi>, עם <bdi dir="ltr">ProvisioningState Succeeded</bdi>; אין <bdi dir="ltr">Containers</bdi> או נתוני משתמש. פריסה שנכשלה אינה תוצאה מובטחת רק משום ש־<bdi dir="ltr">Validate</bdi> הצליח.

**נקודת הוראה:** <bdi dir="ltr">What-if</bdi> אינו משנה משאבים אבל דורש הרשאות כמו פריסה. <bdi dir="ltr">Incremental</bdi> אינו מבטיח שעדכון <bdi dir="ltr">Resource</bdi> קיים לא ישנה את תכונותיו; שמות חדשים ו־<bdi dir="ltr">RG</bdi> חדש מגבילים את הסיכון.

**תקלות נפוצות:** שם תפוס — החליפו סיומת; <bdi dir="ltr">Bicep executable</bdi> חסר — מסוף מעבדה מוכן או <bdi dir="ltr">JSON</bdi> בלבד. <bdi dir="ltr">Policy</bdi> שדורשת <bdi dir="ltr">Tags/TLS</bdi> — אל תבטלו אותה; הציגו את כשל התבנית הבסיסית והשתמשו בסביבה שאושרה מראש. <bdi dir="ltr">JSON</bdi> באזור חסום אינו ניתן לתיקון עם <bdi dir="ltr">`-location`</bdi>.

**ניקוי:** השאירו חשבונות רק להדגמה <bdi dir="ltr">4.</bdi> בסוף בדקו <bdi dir="ltr">Context</bdi>, <bdi dir="ltr">RG</bdi>, <bdi dir="ltr">Tags</bdi> ושמות שני החשבונות; מחקו <bdi dir="ltr">RG</bdi> ייעודי זה עם <bdi dir="ltr">`Remove-AzResourceGroup -Name $rg`</bdi> ואישור. אם <bdi dir="ltr">RG</bdi> הוכן מראש ומשותף, אין למחוק אותו — מסלול ההדגמה דורש <bdi dir="ltr">RG</bdi> בלעדי.

## הדגמה <bdi dir="ltr">4</bdi> — קריאת <bdi dir="ltr">Deployment</bdi>, <bdi dir="ltr">Export</bdi> ו־<bdi dir="ltr">Quickstart</bdi> ללא פריסה נוספת

**מטרה:** להבדיל בין <bdi dir="ltr">Template</bdi> מקורי לתבנית מיוצאת ולהראות כיצד בוחרים <bdi dir="ltr">Quickstart</bdi> בזהירות.

**דרישות:** <bdi dir="ltr">Reader</bdi> למשאבי הדמו; שתי פריסות הדגמה <bdi dir="ltr">3</bdi> קיימות. גישה לדפי <bdi dir="ltr">Microsoft Learn</bdi> ולגלריה הציבורית. אין צורך ברישוי <bdi dir="ltr">Copilot.</bdi>

### צעדים

1. **<bdi dir="ltr">RG > Deployments > m03-json-demo > Template</bdi>**: מצאו <bdi dir="ltr">`$schema`</bdi>, <bdi dir="ltr">`parameters`</bdi>, <bdi dir="ltr">`variables`</bdi>, <bdi dir="ltr">`resources`</bdi>. ב־**<bdi dir="ltr">Inputs</bdi>** הצביעו רק על שם <bdi dir="ltr">Storage</bdi> הדמו; אין <bdi dir="ltr">Secrets</bdi> בפריסה זו.
2. **<bdi dir="ltr">RG > Deployments > m03-bicep-demo > Template</bdi>**: מצאו את <bdi dir="ltr">JSON</bdi> שנוצר מ־<bdi dir="ltr">Bicep.</bdi> הסבירו שה־<bdi dir="ltr">Deployment</bdi> שומר <bdi dir="ltr">ARM JSON</bdi> ולא את כל מבנה המקור של <bdi dir="ltr">Bicep.</bdi>
3. פתחו **<bdi dir="ltr">Storage account</bdi> הדמו > <bdi dir="ltr">Automation > Export template</bdi>**. הציגו את התצוגה בלבד; אם מורידים קובץ, שמרו אותו בתיקיית מעבדה נפרדת ולא מעל <bdi dir="ltr">`Storage.json`</bdi>.
4. השוו <bdi dir="ltr">API version</bdi>, <bdi dir="ltr">Location</bdi> ו־<bdi dir="ltr">Properties</bdi> בין המקור לבין <bdi dir="ltr">Export. Export</bdi> אינו גיבוי נתונים ואינו מבטיח תבנית שלמה לכל <bdi dir="ltr">Resource type.</bdi> אין לייצא <bdi dir="ltr">RG</bdi> ארגוני או לשתף <bdi dir="ltr">Template</bdi> לפני בדיקת מידע רגיש.
5. פתחו [<bdi dir="ltr">Azure Quickstart templates</bdi>](https://azure.microsoft.com/en-us/resources/templates/). חפשו <bdi dir="ltr">Storage account</bdi> פשוט; אם הממשק מציע <bdi dir="ltr">Filter</bdi> ל־<bdi dir="ltr">Azure</bdi> ו־<bdi dir="ltr">JSON</bdi>, השתמשו בו. אפשר להשתמש בדף ההדרכה הרשמי כאשר עיצוב הגלריה משתנה.
6. בדקו <bdi dir="ltr">README</bdi>, רשימת <bdi dir="ltr">Resources</bdi>, <bdi dir="ltr">Parameters</bdi>, <bdi dir="ltr">License</bdi>, <bdi dir="ltr">Region</bdi> ו־<bdi dir="ltr">SKU</bdi> לפני **<bdi dir="ltr">Deploy to Azure</bdi>**. אם פותחים את האשף, נשארים ב־<bdi dir="ltr">Review</bdi> בלבד ולא יוצרים משאבים. אין לבחור <bdi dir="ltr">Quickstart</bdi> של <bdi dir="ltr">VM</bdi>, <bdi dir="ltr">Marketplace paid image</bdi> או פתרון רב־משאבים בלי הערכת עלות.
7. חזרו ל־<bdi dir="ltr">RG</bdi> הדמו ובדקו שלא נוסף <bdi dir="ltr">Resource</bdi> או <bdi dir="ltr">Deployment</bdi> חדש במהלך הסיור.

**תוצאה ואימות:** נראים <bdi dir="ltr">JSON</bdi> מקורי, <bdi dir="ltr">JSON</bdi> מתורגם ו־<bdi dir="ltr">Export</bdi> שנגזר ממשאב חי. רשימת המשאבים לא השתנתה.

**נקודת הוראה:** <bdi dir="ltr">Template</bdi> ציבורי הוא קוד שצריך לקרוא, לא אישור אבטחה או עלות. פרמטר <bdi dir="ltr">`secureString`</bdi> מגן על הצגת ערך, אך אין להכניס סיסמה לתוך <bdi dir="ltr">Source code.</bdi>

**תקלות נפוצות:** <bdi dir="ltr">Export</bdi> מציג אזהרת <bdi dir="ltr">Resource</bdi> לא נתמך — זו מגבלה מוכרת, לא תבנית <bdi dir="ltr">Production</bdi> מוכנה. גלריה לא נגישה — השתמשו בשני הקבצים המקומיים שכבר נבדקו.

**ניקוי:** מחקו רק הורדות <bdi dir="ltr">Export</bdi> של הדמו אם אינן נחוצות. בצעו ניקוי <bdi dir="ltr">RG</bdi> לפי הדגמה <bdi dir="ltr">3.</bdi> אין למחוק קבצי מקור בריפו או <bdi dir="ltr">Storage</bdi> של <bdi dir="ltr">Cloud Shell.</bdi>

## מקורות <bdi dir="ltr">Microsoft</bdi>

- [<bdi dir="ltr">Cloud Shell</bdi> ללא <bdi dir="ltr">Storage account</bdi>](https://learn.microsoft.com/en-us/azure/cloud-shell/get-started/ephemeral)
- [יכולות <bdi dir="ltr">Copilot in Azure</bdi>](https://learn.microsoft.com/en-us/azure/copilot/capabilities)
- <span dir="ltr">[Azure PowerShell — Context](https://learn.microsoft.com/en-us/powershell/azure/context-persistence)</span>
- [<bdi dir="ltr">Azure CLI</bdi> — עבודה עם <bdi dir="ltr">subscriptions</bdi>](https://learn.microsoft.com/en-us/cli/azure/manage-azure-subscriptions-azure-cli)
- [<bdi dir="ltr">What-if</bdi> והרשאות](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-what-if)
- [פריסת <bdi dir="ltr">Bicep</bdi> עם <bdi dir="ltr">Azure CLI</bdi>](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-cli)
- [<bdi dir="ltr">Export template</bdi> בפורטל ומגבלות](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/export-template-portal)
- [פריסה מ־<bdi dir="ltr">Quickstart template</bdi>](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-portal)

</div>
