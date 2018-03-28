package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.dto.GoodsDto;
import com.cqzg168.scm.service.*;
import com.cqzg168.scm.utils.Utils;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Administrator on 2017/7/3 0003.
 */
@Service
@Transactional
public class UploadGoodsExcelServiceImpl implements UploadGoodsExcelService {
    //上传路径
    @Value("${upload_path}")
    private String uploadPath;
    @Autowired
    private GoodsService goodsService;
    @Autowired
    private GoodsCategoryService goodsCategoryService;
    @Autowired
    private GoodsSpecificationService goodsSpecificationService;
    @Autowired
    SupplierService supplierService;

    @Override
    public HashMap<String,Object> uploadExcelFile(MultipartFile file,Manager manager) {
        HashMap<String,Object> resultMap=new HashMap<>();
        String msg="";
        boolean flag=false;
        try {
            String fileOriginalName = file.getOriginalFilename();
            //新图片名称
            String newFileName=new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+"_"+manager.getUsername()+"_"+fileOriginalName.substring(fileOriginalName.lastIndexOf("."));
            File dir = new File(uploadPath + "/goodsExcel");
            if (!dir.exists()) {
                dir.mkdirs();
            }
            File newFile = new File(dir.getAbsolutePath() + File.separator + newFileName);

            newFile.createNewFile();

            file.transferTo(newFile);
            File readFile = new File(newFile.getAbsolutePath());
             resultMap=this.readExcel(readFile);
            return resultMap;
        }catch(Exception e){
            e.printStackTrace();
            flag=false;
            msg="上传excel文件失败";
            resultMap.put("flag",flag);
            resultMap.put("msg",msg);
            return resultMap;
        }

    }

    @Override
    public boolean createExcelAndSaveFile(List<GoodsDto> list, String path) throws IOException {
        OutputStream out = null;
        try {
            File dir = new File(uploadPath + "/resultExcel");
            if (!dir.exists()) {
                dir.mkdirs();
            }
            path=uploadPath+"/resultExcel/"+path;
            Workbook wb = new XSSFWorkbook();
            Sheet sh = wb.createSheet("批量导入商品失败数据");// 创建sheet
            // 创建行
            Row r = sh.createRow(0);
            // 创建表头
            Cell h1 = r.createCell(0);
            h1.setCellValue("商品编码");
            Cell h2 = r.createCell(1);
            h2.setCellValue("商品名称");
            Cell h3 = r.createCell(2);
            h3.setCellValue("条码");
            Cell h4 = r.createCell(3);
            h4.setCellValue("导入失败原因");

            int i = 1;
            if (list != null && list.size() > 0) {
                for (int j = 0; j < list.size(); j++) {
                    Row r1 = sh.createRow(i);
                    // 创建列
                    Cell c1 = r1.createCell(0);
                    c1.setCellValue(list.get(j).getUnifiedCode());
                    Cell c2 = r1.createCell(1);
                    c2.setCellValue(list.get(j).getCname());
                    Cell c3 = r1.createCell(2);
                    c3.setCellValue(list.get(j).getBarcode());
                    Cell c4 = r1.createCell(3);
                    c4.setCellValue(list.get(j).getReason());
                    i++;
                }
            }


            out = new FileOutputStream(path);
            wb.write(out);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
           return false;
        } finally {
            if (out != null) {
                out.flush();
                out.close();
            }
        }

    }

    public HashMap<String,Object> readExcel(File readFile){
        HashMap<String,Object> map=new HashMap<>();
        List<GoodsDto> errorList=new ArrayList<>();
        boolean flag=false;
        String msg="";
        int successCount=0;
        Supplier supplier=supplierService.findOne(-1l);
        try{
            FileInputStream fis = new FileInputStream(readFile);
            Workbook wb = WorkbookFactory.create(fis);
            Sheet sheet = wb.getSheetAt(0);

            List<GoodsDto> goodsList=new ArrayList<>();

            //得到总行数
            int rows = sheet.getPhysicalNumberOfRows();
            for (int r = 1; r < rows; r++) {
                Row row = sheet.getRow(r);
                if (row == null) {
                    continue;
                }



                int cells = row.getLastCellNum();
                GoodsDto goods=new GoodsDto();

                boolean statusFlag=true;

                List<String> reasonList=new ArrayList<>();

                for (int c = 0; c < cells; c++) {
                    Cell cell = row.getCell(c);
                    String value;
                    value = cell == null ? "" : getCellValue(cell);
                    switch (c) {
                        //todo
                        case 0:
                            //商品编码

                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            goods.setGoodsBm(value);
                            break;
                        case 1:
                            //商品名称
                            goods.setCname(value);
                            break;
                        case 2:
                            //商品条码
                            goods.setBarcode(value.trim());
                            break;
                        case 3:
                            //商品大类
                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            if(!Utils.isEmpty(value.trim())) {
                               List<GoodsCategory> list= goodsCategoryService.findByCname(value.trim());
                                if(list.size()==0){
                                    statusFlag = false;
                                    reasonList.add(value.trim()+"大类未找到");
                                }else if(list.size()>1){
                                    statusFlag = false;
                                    reasonList.add(value.trim()+"查询到多个大类");
                                }else{
                                    goods.setGoodsCategoryOne(list.get(0));
                                }
                            }else{
                                statusFlag = false;
                                reasonList.add(value.trim()+"大类不能为空");
                            }
                            break;
                        case 4:
                            //商品小类
                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            if(!Utils.isEmpty(value)) {
                                List<GoodsCategory> list= goodsCategoryService.findByCname(value);

                                if(list.size()==0){
                                    statusFlag = false;
                                    reasonList.add(value.trim()+"小类未找到");
                                }else if(list.size()>1){
                                    statusFlag = false;
                                    reasonList.add(value.trim()+"查询到多个小类");
                                }else{
                                    goods.setGoodsCategoryTwo(list.get(0));
                                }

                            }else{
                                statusFlag = false;
                                reasonList.add(value.trim()+"小类不能为空");
                            }
                            break;
                        case 5:
                            //规格名称
                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            goods.setSpecificationName(value.trim());
                            break;
                        case 6:
                            //进价
                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            goods.setCost(value.trim());
                            break;
                        case 7:
                            //售价
                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            goods.setPrice(value.trim());
                            break;
                        case 8:
                            //建议零售价
                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            goods.setSuggestPrice(value.trim());
                            break;
                        case 9:
                            //最小起批量
                            if(value.contains(".0")){
                                value = value.substring(0,value.length()-2);
                            }
                            if(!Utils.isNull(value.trim())){
                            goods.setSaleCount(Integer.parseInt(value.trim()));
                            }else{
                                statusFlag = false;
                                reasonList.add(value.trim()+"最小起批量不能为空");
                            }
                            break;

                    }


                }
                if(statusFlag) {
                    goods.setSupplier(supplier);
                    goodsList.add(goods);
                }else{
                    String reason="";
                    for(String s:reasonList){
                        reason=reason+";"+s;
                    }
                    goods.setReason(reason);
                    errorList.add(goods);
                }


            }
            System.out.println("成功读取数据"+goodsList.size()+"????"+errorList.size());
            if(goodsList.size()>0){
                for(GoodsDto g:goodsList){

                    List<String> reasonList=new ArrayList<>();
                    if(!Utils.isEmpty(g.getGoodsBm().trim())){
                        //有商品编码的数据
                        List<GoodsSpecification> findList=goodsSpecificationService.findByGoodsBm(g.getGoodsBm());
                        if(findList.size()>1){
                            //查询到的多条数据，不做操作
                            g.setReason("商品编码"+g.getGoodsBm()+"查询到多条记录");
                            errorList.add(g);
                        }else if(findList.size()==1){
//                            if(!Utils.isEmpty(g.getCname())){
//                            findList.get(0).setCname(g.getCname());
//                            }
//                            if(!Utils.isEmpty(g.getPrice())){
//                                findList.get(0).setPrice(new BigDecimal(g.getPrice()));
//                            }
//                            if(!Utils.isEmpty(g.getCost())){
//                                findList.get(0).setCost(new BigDecimal(g.getCost()));
//                            }
//                            if(!Utils.isEmpty(g.getSuggestPrice())){
//                                findList.get(0).setSuggestPrice(new BigDecimal(g.getSuggestPrice()));
//                            }
//                            goodsSpecificationService.save(findList.get(0));
//                            //修改商品基本信息
//                            Goods goods=goodsService.findOne(findList.get(0).getGoodsSid());
//                            if(!Utils.isNull(goods)){
//                                if(!Utils.isEmpty(g.getCname())){
//                                    goods.setCname(g.getCname());
//                                }
//                                if(!Utils.isNull(g.getGoodsCategoryOne())){
//                                    goods.setGoodsCategoryOne(g.getGoodsCategoryOne());
//                                }
//                                if(!Utils.isNull(g.getGoodsCategoryTwo())){
//                                    goods.setGoodsCategoryTwo(g.getGoodsCategoryTwo());
//                                }
//                                goodsService.save(goods);
//                            }
                            successCount+=1;
                        }else if(findList.size()==0){
                            //新增操作
                            //先判断商品基本信息是否存在
                            List<String> list=new ArrayList<>();
                            boolean addFlag=true;
                            //先判断商品基本信息是否存在
                            List<Goods> listGoods=goodsService.findByCname(g.getCname());

                            if(listGoods.size()>1){
                                list.add(g.getCname()+"名称重复");
                            }else if(listGoods.size()==0) {
                                //商品基本不存在，需要新增商品基本信息，价格信息可能会新增
                                Goods addGoods=new Goods();
                                if (Utils.isEmpty(g.getCname())) {
                                    addFlag = false;
                                    list.add("新增时商品名称不能为空");

                                }else{
                                    addGoods.setCname(g.getCname());
                                }

                                if (Utils.isNull(g.getGoodsCategoryOne())) {
                                    addFlag = false;
                                    list.add("新增时商品商品大类不能为空");
                                }else{
                                    addGoods.setGoodsCategoryOne(g.getGoodsCategoryOne());
                                }
                                if (Utils.isNull(g.getGoodsCategoryOne())) {
                                    addFlag = false;
                                    list.add("新增时商品小类不能为空");
                                }else{
                                    addGoods.setGoodsCategoryTwo(g.getGoodsCategoryTwo());
                                }

                                if (addFlag) {
                                    addGoods.setFreeGoods(1);
                                    addGoods.setSupplier(g.getSupplier());
                                    addGoods=goodsService.save(addGoods);
                                    if(!Utils.isEmpty(g.getCost()) && !Utils.isEmpty(g.getPrice()) && !Utils.isEmpty(g.getSuggestPrice()) && !Utils.isNull(g.getSaleCount())){
                                        GoodsSpecification addGoodsSpecification=new GoodsSpecification();
                                        addGoodsSpecification.setGoodsBm(g.getGoodsBm());
                                        if(!Utils.isEmpty(g.getSpecificationName())){
                                            addGoodsSpecification.setCname(g.getSpecificationName());
                                        }else{
                                        addGoodsSpecification.setCname("默认规格");
                                        }
                                        addGoodsSpecification.setSaleCount(g.getSaleCount());
                                        addGoodsSpecification.setBarcode(g.getBarcode());
                                        addGoodsSpecification.setSuggestPrice(new BigDecimal(g.getSuggestPrice()).setScale(2,BigDecimal.ROUND_DOWN));
                                        addGoodsSpecification.setPrice(new BigDecimal(g.getPrice()).setScale(2,BigDecimal.ROUND_DOWN));
                                        addGoodsSpecification.setCost(new BigDecimal(g.getCost()).setScale(2,BigDecimal.ROUND_DOWN));
                                        addGoodsSpecification.setStatus(1);
                                        addGoodsSpecification.setGoodsSid(addGoods.getSid());
                                        goodsSpecificationService.save(addGoodsSpecification);
                                        successCount += 1;
                                    }else{
                                        System.out.println("价格信息添加失败ddddd"+addGoods.getCname());
                                        GoodsDto goodsDto = new GoodsDto(g);
                                        goodsDto.setReason("商品基本信息新增成功，价格信息新增失败");
                                        errorList.add(goodsDto);
                                    }
                                } else {
                                    String reason = "";
                                    GoodsDto goodsDto = new GoodsDto(g);
                                    for (String s : list) {
                                        reason = reason + ";" + s;
                                    }
                                    goodsDto.setReason(reason);
                                    errorList.add(goodsDto);
                                }
                            }else if(listGoods.size()==1) {
                                //商品基本信息存在，价格需要新增
                                if (!Utils.isNull(g.getGoodsCategoryOne())) {
                                    listGoods.get(0).setGoodsCategoryOne(g.getGoodsCategoryOne());
                                }
                                if (!Utils.isNull(g.getGoodsCategoryTwo())) {
                                    listGoods.get(0).setGoodsCategoryTwo(g.getGoodsCategoryTwo());
                                }
                                Goods updateGoods = goodsService.save(listGoods.get(0));
                                List<GoodsSpecification> specificationList = goodsSpecificationService.findByGoodsBm(g.getGoodsBm());
                                if (specificationList.size() == 0) {

                                if (!Utils.isEmpty(g.getCost()) && !Utils.isEmpty(g.getPrice()) && !Utils.isEmpty(g.getSuggestPrice()) && !Utils.isNull(g.getSaleCount())) {
                                    GoodsSpecification addGoodsSpecification = new GoodsSpecification();
                                    addGoodsSpecification.setGoodsBm(g.getGoodsBm());
                                    if(!Utils.isEmpty(g.getSpecificationName())){
                                        addGoodsSpecification.setCname(g.getSpecificationName());
                                    }else{
                                        addGoodsSpecification.setCname("默认规格");
                                    }
                                    addGoodsSpecification.setSaleCount(g.getSaleCount());
                                    addGoodsSpecification.setBarcode(g.getBarcode());
                                    addGoodsSpecification.setSuggestPrice(new BigDecimal(g.getSuggestPrice()).setScale(2,BigDecimal.ROUND_DOWN));
                                    addGoodsSpecification.setPrice(new BigDecimal(g.getPrice()).setScale(2,BigDecimal.ROUND_DOWN));
                                    addGoodsSpecification.setCost(new BigDecimal(g.getCost()).setScale(2,BigDecimal.ROUND_DOWN));
                                    addGoodsSpecification.setGoodsSid(updateGoods.getSid());
                                    addGoodsSpecification.setStatus(1);
                                    goodsSpecificationService.save(addGoodsSpecification);
                                    successCount += 1;
                                } else {
                                    System.out.println("价格信息添加失败ccccc" + updateGoods.getCname());
                                    GoodsDto goodsDto = new GoodsDto(g);
                                    goodsDto.setReason("商品基本信息修改成功，价格信息新增失败");
                                    errorList.add(goodsDto);
                                }
                            }else if (specificationList.size()==1){
                                    specificationList.get(0).setSuggestPrice(new BigDecimal(g.getSuggestPrice()).setScale(2,BigDecimal.ROUND_DOWN));
                                    specificationList.get(0).setPrice(new BigDecimal(g.getPrice()).setScale(2,BigDecimal.ROUND_DOWN));
                                    specificationList.get(0).setCost(new BigDecimal(g.getCost()).setScale(2,BigDecimal.ROUND_DOWN));
                                    goodsSpecificationService.save(specificationList.get(0));
                                    successCount += 1;
                                }else if(specificationList.size()>1){

                                    System.out.println("根据商品编码查询到多条商品规格"+g.getGoodsBm());
                                    GoodsDto goodsDto = new GoodsDto(g);
                                    goodsDto.setReason("商品基本信息修改成功，根据商品编码查询到多条商品规格，价格信息新增失败");
                                    errorList.add(goodsDto);
                                }

                            }else{
                                System.out.println("?????????????????????"+listGoods.size());
                            }

                        }

                }else{
                        //没有商品编码数据
                        //新增操作
                        //先判断商品基本信息是否存在
                        List<String> list=new ArrayList<>();
                        boolean addFlag=true;
                        //先判断商品基本信息是否存在
                        List<Goods> listGoods=goodsService.findByCname(g.getCname());

                        if(listGoods.size()>1){
                            list.add(g.getCname()+"名称重复");
                        }else if(listGoods.size()==0) {
                            //商品基本不存在，需要新增商品基本信息，价格信息可能会新增
                            Goods addGoods=new Goods();
                            if (Utils.isEmpty(g.getCname())) {
                                addFlag = false;
                                list.add("新增时商品名称不能为空");

                            }else{
                                addGoods.setCname(g.getCname());
                            }

                            if (Utils.isNull(g.getGoodsCategoryOne())) {
                                addFlag = false;
                                list.add("新增时商品商品大类不能为空");
                            }else{
                                addGoods.setGoodsCategoryOne(g.getGoodsCategoryOne());
                            }
                            if (Utils.isNull(g.getGoodsCategoryOne())) {
                                addFlag = false;
                                list.add("新增时商品小类不能为空");
                            }else{
                                addGoods.setGoodsCategoryTwo(g.getGoodsCategoryTwo());
                            }

                            if (addFlag) {
                                addGoods.setFreeGoods(1);
                                addGoods.setSupplier(supplier);
                                addGoods=goodsService.save(addGoods);
                                if(!Utils.isEmpty(g.getCost()) && !Utils.isEmpty(g.getPrice()) && !Utils.isEmpty(g.getSuggestPrice()) && !Utils.isNull(g.getSaleCount())){
                                    GoodsSpecification addGoodsSpecification=new GoodsSpecification();
                                    addGoodsSpecification.setGoodsBm(g.getGoodsBm());
                                    if(!Utils.isEmpty(g.getSpecificationName())){
                                        addGoodsSpecification.setCname(g.getSpecificationName());
                                    }else{
                                        addGoodsSpecification.setCname("默认规格");
                                    }
                                    addGoodsSpecification.setSaleCount(g.getSaleCount());
                                    addGoodsSpecification.setBarcode(g.getBarcode());
                                    addGoodsSpecification.setSuggestPrice(new BigDecimal(g.getSuggestPrice()).setScale(2,BigDecimal.ROUND_DOWN));
                                    addGoodsSpecification.setPrice(new BigDecimal(g.getPrice()).setScale(2,BigDecimal.ROUND_DOWN));
                                    addGoodsSpecification.setCost(new BigDecimal(g.getCost()).setScale(2,BigDecimal.ROUND_DOWN));
                                    addGoodsSpecification.setStatus(1);
                                    addGoodsSpecification.setGoodsSid(addGoods.getSid());
                                    goodsSpecificationService.save(addGoodsSpecification);
                                    successCount += 1;
                                }else{
                                        System.out.println("价格信息添加失败aaaaa"+addGoods.getCname());
                                    GoodsDto goodsDto = new GoodsDto(g);
                                    goodsDto.setReason("商品基本信息新增成功，价格信息新增失败");
                                    errorList.add(goodsDto);
                                }
                            } else {
                                String reason = "";
                                GoodsDto goodsDto = new GoodsDto(g);
                                for (String s : list) {
                                    reason = reason + ";" + s;
                                }
                                goodsDto.setReason(reason);
                                errorList.add(goodsDto);
                            }
                        }else if(listGoods.size()==1){
                            //商品基本信息存在，价格需要新增
                            if(!Utils.isNull(g.getGoodsCategoryOne())){
                                listGoods.get(0).setGoodsCategoryOne(g.getGoodsCategoryOne());
                            }
                            if(!Utils.isNull(g.getGoodsCategoryTwo())){
                                listGoods.get(0).setGoodsCategoryTwo(g.getGoodsCategoryTwo());
                            }
                            Goods   updateGoods=goodsService.save(listGoods.get(0));
                            if(!Utils.isEmpty(g.getCost()) && !Utils.isEmpty(g.getPrice()) && !Utils.isEmpty(g.getSuggestPrice())){
                                GoodsSpecification addGoodsSpecification=new GoodsSpecification();
                                addGoodsSpecification.setGoodsBm(g.getGoodsBm());
                                addGoodsSpecification.setCname("默认规格");
                                addGoodsSpecification.setBarcode(g.getBarcode());
                                addGoodsSpecification.setSuggestPrice(new BigDecimal(g.getSuggestPrice()).setScale(2,BigDecimal.ROUND_DOWN));
                                addGoodsSpecification.setPrice(new BigDecimal(g.getPrice()).setScale(2,BigDecimal.ROUND_DOWN));
                                addGoodsSpecification.setCost(new BigDecimal(g.getCost()).setScale(2,BigDecimal.ROUND_DOWN));
                                addGoodsSpecification.setGoodsSid(updateGoods.getSid());
                                addGoodsSpecification.setStatus(1);
                                goodsSpecificationService.save(addGoodsSpecification);
                                successCount += 1;
                            }else{
                                System.out.println("价格信息添加失败bbbbb"+updateGoods.getCname());
                                GoodsDto goodsDto = new GoodsDto(g);
                                goodsDto.setReason("商品基本信息修改成功，价格信息新增失败");
                                errorList.add(goodsDto);
                            }

                        }else{
                        }
                    }
                }
            }
            flag=true;
            map.put("flag",flag);
            if(errorList.size()>0){
                msg=errorList.size()+" 条数据导入失败，"+successCount+" 条数据导入成功";
                map.put("errorList",errorList);
            }else{
                msg=successCount+"条数据导入成功";
            }
            map.put("msg",msg);

            return map;


//            return "读取成功";

        }catch(Exception e){
            e.printStackTrace();
            flag=false;
            msg="文件上传成功，读取excle数据失败";
            map.put("flag",flag);
            map.put("msg",msg);
            return map;
        }


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
}
