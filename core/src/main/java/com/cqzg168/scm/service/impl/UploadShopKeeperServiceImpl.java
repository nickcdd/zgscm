package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Goods;
import com.cqzg168.scm.domain.GoodsCategory;
import com.cqzg168.scm.domain.GoodsSpecification;
import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.dto.GoodsDto;
import com.cqzg168.scm.service.ShopKeeperService;
import com.cqzg168.scm.service.UploadShopKeeperService;
import com.cqzg168.scm.utils.Utils;
import org.apache.poi.ss.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.FileInputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by Administrator on 2017/7/12 0012.
 */
@Service
@Transactional
public class UploadShopKeeperServiceImpl implements UploadShopKeeperService {
    @Autowired
    ShopKeeperService shopKeeperService;

    public HashMap<String,Object> readExcel(File readFile){
        HashMap<String,Object> map=new HashMap<>();
        List<ShopKeeper> errorList=new ArrayList<>();
        File file=new File("D:\\shopkeeper.xls");
        try{
            FileInputStream fis = new FileInputStream(file);
            Workbook wb = WorkbookFactory.create(fis);
            Sheet sheet = wb.getSheetAt(0);
            List<ShopKeeper> shopKeepersList=new ArrayList<>();
            //得到总行数
            int rows = sheet.getPhysicalNumberOfRows();
            for (int r = 1; r < rows; r++) {
                Row row = sheet.getRow(r);
                if (row == null) {
                    continue;
                }
                int cells = row.getLastCellNum();
                ShopKeeper shopKeeper=new ShopKeeper();
                for (int c = 0; c < cells; c++) {
                    Cell cell = row.getCell(c);
                    String value;
                    value = cell == null ? "" : getCellValue(cell);
                    switch (c) {
                        //todo
                        case 0:
                            //店名

                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            shopKeeper.setCname(value);

                            break;
                        case 1:
                            //姓名
                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            shopKeeper.setRealName(value);

                            break;
                        case 2:
                            //手机
                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            System.out.println("------"+value);
                            shopKeeper.setTelephone(value);
                            String password=value.substring(value.length()-6,value.length());
                            password=Utils.getMD5String(password);
                            shopKeeper.setPassword(password);

                            break;
                        case 3:
                            //省
                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            shopKeeper.setProvince(value);

                            break;
                        case 4:
                            //市
                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            shopKeeper.setCity(value);

                            break;
                        case 5:
                            //区
                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            shopKeeper.setArea(value);

                            break;
                        case 6:
                            //地址
                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            shopKeeper.setAddress(value);

                            break;
                    }
                }
                shopKeeper.setLevel(0);
                shopKeepersList.add(shopKeeper);
            }
            shopKeeperService.save(shopKeepersList);
        }catch (Exception e){
            e.printStackTrace();
            return  map;
        }



        return map;

    }
    private String getCellValue(Cell cell) {
        switch (cell.getCellTypeEnum()) {

            case FORMULA:
                return cell.getCellFormula();

            case NUMERIC:
                return "" + cell.getNumericCellValue();

            case STRING:
                return cell.getStringCellValue();

            case BLANK:
                return "";

            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());

            default:
                return cell.toString();
        }
    }

    @Override
    public void test() {
        this.readExcel(null);
    }
}
