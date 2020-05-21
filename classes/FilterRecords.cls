/*
 * MIT License
 *
 * Copyright (c) 2020 https://github.com/mritzi
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

public class FilterRecords {
    /***** public vars*****/
    
    /***** private/protected vars*****/
    private Boolean throwException = false;
	private List<sObject> objList;
    private Map<Id, sObject> oldMap;
    private Set<Object> fieldValueSet;
    private String rootObjName;
    
    private final static String EQ = 'EQ';
    private final static String NEQ = 'NEQ';
    private final static String GT = 'GT';
    private final static String GE = 'GE';
    private final static String LT = 'LT';
    private final static String LE = 'LE';
    private final static String INLIST = 'INL';
    private final static String NOTINLIST = 'NINL';
    
    /***** constructors *****/
    
    public FilterRecords(List<sObject> objList){
        this(objList, new Map<Id, sObject>());
    }
    
    public FilterRecords(
        List<SObject> objList, Map<Id, sObject> oldMap)
    {
        this.objList = (objList != null) ? 
            objList : new List<sObject>();
        this.oldMap = (oldMap != null) ? 
            oldMap : new Map<Id, sObject>();
        fieldValueSet = new Set<Object>();
        
        if(isObjListEmpty()){
            handleError('List has no elements', true);
        }
        rootObjName = String.valueOf(objList[0].getSObjectType());
    }
    
    /**************************/
    /***** public methods *****/
    /**************************/
    
    
    public List<sObject> getList(){
        return objList;
    }
    
    public List<String> getFieldValueList(){
        return getStringList();
    }
    
    public List<Id> getParentIdList(){
        return getIdList();
    }
    
    public FilterRecords enforceException(Boolean flag){
        this.throwException = flag;
        return this;
    }
    
    /***** intermediate public method calls *****/
    
    /***** methods that works on list *****/
    
    public FilterRecords byField(String fieldApi)
    {
        Set<Object> tempObjList = new Set<Object>();
        for(sObject obj : objList){
            System.debug(obj);
            if(obj.isSet(fieldApi)){
                tempObjList.add(obj.get(fieldApi));
            }
        }        
        fieldValueSet = tempObjList;
        return this;
    }
    
    public FilterRecords byFieldValueEq(
        String fieldApi, Object fieldValue)
    {
        List<sObject> tempObjList = new List<sObject>();
        for(sObject obj : objList){
            if(obj.get(fieldApi) == fieldValue){
                tempObjList.add(obj);
            }
        }        
        objList = tempObjList;
        return this;
    }
    
    public FilterRecords byFieldValueNotEq(
        String fieldApi, Object fieldValue)
    {
        List<sObject> tempObjList = new List<sObject>();
        for(sObject obj : objList){
            if(obj.get(fieldApi) != fieldValue){
                tempObjList.add(obj);
            }
        }        
        objList = tempObjList;
        return this;
    }
    
    public FilterRecords byRecordTypeIdEq(Id fieldValue){
        return byFieldValueEq('RecordTypeId', fieldValue);
    }
    
    public FilterRecords byRecordTypeIdNotEq(String fieldValue){
        return byFieldValueNotEq('RecordTypeId', fieldValue);
    }
    
    public FilterRecords byRecordTypeNameEq(String fieldValue){
        Id recordTypeId = getRecordTypeId(fieldValue);
        return byFieldValueEq('RecordTypeId', fieldValue);
    }
    
    public FilterRecords byRecordTypeNameNotEq(String fieldValue){
        Id recordTypeId = getRecordTypeId(fieldValue);
        return byFieldValueNotEq('RecordTypeId', fieldValue);
    }
    
    public FilterRecords byFieldValueGT(
        String fieldApi, Object fieldValue)
    {
        return this;
    }
    
    public FilterRecords byFieldValueGE(
        String fieldApi, Object fieldValue)
    {
        return this;
    }
    
    public FilterRecords byFieldValueLT(
        String fieldApi, Object fieldValue)
    {
        return this;
    }
    
    public FilterRecords byFieldValueLE(
        String fieldApi, Object fieldValue)
    {
        return this;
    }
    
    
    /***** methods that works on list + oldMap *****/
    
    public FilterRecords byNewValueEq(
        String fieldApi, Object fieldValue)
    {
        byFieldValueChanged(fieldApi);
        byFieldValueEq(fieldApi, fieldValue);
        return this;
    }
    
    public FilterRecords byNewValueNotEq(
        String fieldApi, Object fieldValue)
    {
        byFieldValueChanged(fieldApi);
        byFieldValueNotEq(fieldApi, fieldValue);
        return this;
    }
    
    public FilterRecords byOldValueEq(
        String fieldApi, Object fieldValue)
    {
        byFieldValueChanged(fieldApi);
        byOldFieldValueEq(fieldApi, fieldValue);
        return this;
    }
    
    public FilterRecords byOldValueNotEq(
        String fieldApi, Object fieldValue)
    {
        byFieldValueChanged(fieldApi);
        byOldFieldValueNotEq(fieldApi, fieldValue);
        return this;
    }
        
    public FilterRecords byNewValueIn(
        String fieldApi, List<Object> fieldValueList)
    {
        byFieldValueChanged(fieldApi);
        return this;
    }
    
    public FilterRecords byNewValueNotIn(
        String fieldApi, List<Object> fieldValueList)
    {
        return this;
    }
    
    public FilterRecords byOldValueIn(
        String fieldApi, List<Object> fieldValueList)
    {
        return this;
    }
    
    public FilterRecords byOldValueNotIn(
        String fieldApi, List<Object> fieldValueList)
    {
        return this;
    }
        
    
    /*****************************/
    /***** protected methods *****/
    /*****************************/
    
    // nothing here as of now
    
    /***************************/
    /***** private methods *****/
    /***************************/
    
    private void byFieldValueChanged(String fieldApi){
        List<sObject> tempObjList = new List<sObject>();
        for(sObject obj : objList){
            sObject oldObj = oldMap.get(obj.Id);
            if(obj.get(fieldApi) != oldObj.get(fieldApi)){
                tempObjList.add(obj);
            }
        }
        objList = tempObjList;
    }
    
    private void byOldFieldValueEq(String fieldApi, Object fieldValue){
        List<sObject> tempObjList = new List<sObject>();
        for(sObject obj : objList){
            sObject oldObj = oldMap.get(obj.Id);
            if(oldObj.get(fieldApi) == fieldValue){
                tempObjList.add(obj);
            }
        }
        objList = tempObjList;
    }
    
    private void byOldFieldValueNotEq(String fieldApi, Object fieldValue){
        List<sObject> tempObjList = new List<sObject>();
        for(sObject obj : objList){
            sObject oldObj = oldMap.get(obj.Id);
            if(oldObj.get(fieldApi) != fieldValue){
                tempObjList.add(obj);
            }
        }
        objList = tempObjList;
    }
    
    private void filterListByRootField(
        String fieldApi, String fieldValue, 
        List<Object> fieldValueList, String operation)
    {
        List<sObject> tempObjList = new List<sObject>();
        String fileldType = Schema.describeSObjects(new List<String>{rootObjName})[0]
            .fields.getMap().get(fieldApi).getDescribe().getSOAPType().name();
        Object obj1;
        Type t = Type.forName('Integer');
        //Integer int = t.newInstance();
        for(sObject obj : objList){
            Boolean isMatch = false;
            switch on operation{
                when 'EQ' {
                    isMatch = obj.get(fieldApi) == fieldValue;
                }
                when 'NEQ' {
                    isMatch = obj.get(fieldApi) != fieldValue;
                }
                when 'IN' {
                    isMatch = fieldValueList.contains(obj.get(fieldApi));
                }
                when 'NIN' {
                    isMatch = !fieldValueList.contains(obj.get(fieldApi));
                }/*
                when 'GT' {
                    isMatch = obj.get(fieldApi) > fieldValue;
                }
                when 'GE' {
                    isMatch = obj.get(fieldApi) >= fieldValue;
                }
                when 'LT' {
                    isMatch = obj.get(fieldApi) < fieldValue;
                }
                when 'LE' {
                    isMatch = obj.get(fieldApi) <= fieldValue;
                }*/
                when else{
                    continue;
                }
            }
            if(isMatch){
                tempObjList.add(obj);
            }
        }        
        objList = tempObjList;
    }
	
    private List<Object> getObjectList(List<String> strList){
        Set<Object> objSet = new Set<Object>();
        for(String str : strList){
            objSet.add(str);
        }
        return new List<Object>(objSet);
    }
    
    private List<Object> getObjectSet(Set<String> strSet){
        return getObjectList(
            new List<String>(strSet)
        );
    }
    
    private Id getRecordTypeId(String recordTypeName){
        return Schema.describeSObjects(new List<String>{rootObjName})[0]
            .getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    }
    
    private List<String> getStringList(){
        List<String> fieldValueList = new List<String>();
        for(Object obj : fieldValueSet){
            fieldValueList.add(
            	String.valueOf(obj)
            );
        }
        return fieldValueList;
    }
    
    private List<Id> getIdList(){
        return getStringList();
    }
    
    private Boolean isObjListEmpty(){
        return objList.size() == 0;
    }
    
    private void handleError(String errorMsg){
        handleError(errorMsg, throwException);
    }
    
    private void handleError(String errorMsg, Boolean flag){
        if(flag){
            throw new FilterRecordsException(errorMsg);
        }
        else{
            System.debug('Following error occurred in FilterRecords class : \n'
                         + errorMsg);
        }
    }
    
    /*************************/
    /***** inner classes *****/
    /*************************/
    
    
    public class FilterRecordsException extends Exception {}

}