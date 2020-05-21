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

@isTest
public class FilterRecordsTest {
	
    @testSetup
    public static void createData(){
        // nothing here as of now
    }
    
    @isTest
    public static void test_byFieldValue(){
        List<Account> account_list = getSampleAccountList();
        
        Test.startTest();
        List<String> account_type_list = 
            new FilterRecords(account_list)
            .byField('Type')
            .getFieldValueList();
        Test.stopTest();
        // all accounts have same value in 'Type' field
        System.assertEquals(1, account_type_list.size());
    }
    
    /***** private methods *****/
    
    private static List<Account> getSampleAccountList(){
        List<Account> account_list = new List<Account>();
        for(Integer i=0; i<5; i++){
            Account account = new Account();
            account.Name = 'Test Account ' + i;
            account.Type = 'Customer';
            account.Website = 'www.samplewebsite' + i + '.com';
            account.AnnualRevenue =  10000 * i;
            
            account_list.add(account);
        }
        return account_list;
    }
}