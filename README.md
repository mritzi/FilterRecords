# FilterRecords


## Why FilterRecords

- While developing custom feature in Salesforce, often times we need to write repetitive code to filter list based on certain filter criteria. We have to write for loop to iterate over list of sObjects & get records relevant to the use case, and it's repeated at several places in the org.
- Similar situation comes up regularly while handling records in Trigger context, where Trigger.new & Trigger.old gives up upto 200 records of all record types. However,  we only need to run a use case on records of a certain record type.

This library aims to remove that re-work and make the org's code size smaller.

```javascript
List<Account> ecom_account_list =
    new FilterRecords(Trigger.new)
    .byFieldValueEq('Industry', 'E-Commerce')
    .getList();
```

Easy, isn't it!!!


## Features

- Allows functional programming inspired method chaining while using object oriented programming paradigm of Apex

- It improves developer efficiency, as developer can quickly get relevant data and pass it to relevant apex method/class for further processing.

- It's designed to be easily readable for devs & admins alike.


## Examples

### Filter records by RecordType

This will return a list of all Accounts where RecordTypeId = '1234abcd..AAC'

```javascript
List<Account> supplier_account_list =
    new FilterRecords(Trigger.new)
    .byRecordTypeIdEq('RecordTypeId', '1234abcd..AAC')
    .getList();
```

### Filter records by Picklist value

This will return a list of all Accounts where Indusry = 'E-Commerce'

```javascript
List<Account> account_list = <collection of all types of accounts>
List<Account> ecom_account_list =
    new FilterRecords(account_list)
    .byFieldValueEq('Industry', 'E-Commerce')
    .getList();
```


### Filter records by negative filter condition

This will return a list of all Accounts where Indusry != 'E-Commerce'

```javascript
List<Account> account_list = <collection of all types of accounts>
List<Account> filtered_account_list =
    new FilterRecords(account_list)
    .byFieldValueNotEq('Industry', 'E-Commerce')
    .getList();
```

### Filter records in Trigger context where field values have changed

This will return a list where City changed from Miami to Texas

```javascript
List<Account> filtered_account_list =
    new FilterRecords(Trigger.new, Trigger.oldMap)
    .byOldValueEq('ShippingCity', 'Miami')
    .byNewValueEq('ShippingCity', 'Miami')
    .getList();
```


More changes under development, stay connected!!
