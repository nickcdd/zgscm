package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Manager;
import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.OrdersGoods;
import com.cqzg168.scm.dto.GoodsDto;
import com.cqzg168.scm.dto.OrdersGoodsDto;
import com.cqzg168.scm.service.OrdersGoodsService;
import com.cqzg168.scm.service.OrdersService;
import com.cqzg168.scm.service.UploadPickingGoodsExcelService;
import com.cqzg168.scm.utils.Utils;
import org.apache.poi.ss.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.rmi.CORBA.Util;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Administrator on 2017/7/14 0014.
 */
@Service
@Transactional
public class UploadPickingGoodsExcelServiceImpl implements UploadPickingGoodsExcelService {
    //上传路径
    @Value("${upload_path}")
    private String uploadPath;
    @Autowired
    OrdersGoodsService ordersGoodsService;
    @Autowired
    OrdersService ordersService;

    @Override
    public HashMap<String, Object> uploadExcelFile(MultipartFile file, Manager manager) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String msg = "";
        boolean flag = false;
        try {
            String fileOriginalName = file.getOriginalFilename();
            //新图片名称
//            String newFileName = UUID.randomUUID() + fileOriginalName.substring(fileOriginalName.lastIndexOf("."));
            String newFileName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + "_" + manager.getUsername() + "_" + fileOriginalName.substring(fileOriginalName.lastIndexOf("."));
            File dir = new File(uploadPath + "/pickingGoodsExcel");
            if (!dir.exists()) {
                dir.mkdirs();
            }
            File newFile = new File(dir.getAbsolutePath() + File.separator + newFileName);

            newFile.createNewFile();

            file.transferTo(newFile);
            File readFile = new File(newFile.getAbsolutePath());
            resultMap = this.readExcel(readFile, manager);
            return resultMap;
        } catch (Exception e) {
            e.printStackTrace();
            flag = false;
            msg = "上传excel文件失败";
            resultMap.put("flag", flag);
            resultMap.put("msg", msg);
            return resultMap;
        }
    }

    @Override
    public boolean createExcelAndSaveFile(List<GoodsDto> list, String path) throws IOException {
        return false;
    }

    public HashMap<String, Object> readExcel(File readFile, Manager manager) {
        HashMap<String, Object> map = new HashMap<>();
        List<OrdersGoodsDto> haveList = new ArrayList<>();
        boolean flag = true;
        String msg = "";
        try {
            FileInputStream fis = new FileInputStream(readFile);
            Workbook wb = WorkbookFactory.create(fis);
            Sheet sheet = wb.getSheetAt(0);
            //得到总行数
            int rows = sheet.getPhysicalNumberOfRows();
            boolean statusFalg = true;
            for (int r = 1; r < rows; r++) {
                Row row = sheet.getRow(r);
                if (row == null) {
                    continue;
                }
                int cells = row.getLastCellNum();
                OrdersGoodsDto ordersGoodsDto = new OrdersGoodsDto();

                for (int c = 0; c < cells; c++) {
                    Cell cell = row.getCell(c);
                    String value;
                    value = cell == null ? "" : getCellValue(cell);
                    switch (c) {
                        //todo
                        case 2:
                            //订单编号
                            if (value.contains(".0")) {
                                value = value.substring(0, value.length() - 2);
                            }

                            if (Utils.isEmpty(value)) {
                                statusFalg = false;
                            }
                            ordersGoodsDto.setOrdersSid(Long.parseLong(value));
                            break;
                        case 10:
                            //商品编码

                            if (value.contains(".0")) {
                                value = value.substring(0, value.length() - 2);
                            }
                            ordersGoodsDto.setGoodsBm(value);
//                            System.out.println("商品编码" + value);
                            break;
//                        case 8:
//                            //商品条码
                        case 16:
                            //是否有货

                            if (value.contains(".0")) {
                                value = value.substring(0, value.length() - 2);
                            }

                            if (!Utils.isEmpty(value)) {
                                ordersGoodsDto.setStatus(Integer.parseInt(value));
                            } else {
                                ordersGoodsDto.setStatus(null);
                            }
                            break;
                    }
                }
                if (Utils.isNull(ordersGoodsDto.getOrdersSid()) || Utils.isEmpty(ordersGoodsDto.getGoodsBm())) {
                    flag = false;
                    msg = "数据表数据不完整，导入失败";
                    map.put("flag", flag);
                    map.put("msg", msg);
                    break;
                } else {
                    Orders orders = ordersService.findOne(ordersGoodsDto.getOrdersSid());
                    if (!Utils.isNull(orders)) {
                        if (orders.getStatus() == 7) {
                            haveList.add(ordersGoodsDto);
                        } else {
                            flag = false;
                            msg = "订单号，" + ordersGoodsDto.getOrdersSid() + "不是待分拣状态，请检查后重新导入";
                            map.put("flag", flag);
                            map.put("msg", msg);
                            break;
                        }
                    } else {
                        flag = false;
                        msg = "订单号，" + ordersGoodsDto.getOrdersSid() + "没有找到，请检查后重新导入";
                        map.put("flag", flag);
                        map.put("msg", msg);
                        break;
                    }
                }
            }
            if (flag) {
                boolean resultFlag = this.findOrderGoods(haveList, manager);
                if (resultFlag) {
//                    flag = true;
                    msg = "操作成功";
                    map.put("flag", true);
                    map.put("msg", msg);
                } else {
                    msg = "拣货失败，请从新上传";
                    map.put("flag", false);
                    map.put("msg", msg);
                }
            }
            return map;
        } catch (Exception e) {
            e.printStackTrace();
            e.printStackTrace();
            flag = false;
            msg = "文件上传成功，读取excle数据失败";
            map.put("flag", flag);
            map.put("msg", msg);
            return map;
        }


    }

    public boolean findOrderGoods(List<OrdersGoodsDto> list, Manager manager) {

        Map<String, List<Long>> map = new HashMap<>();
        List<Long> checkList = new ArrayList<>();
        for (OrdersGoodsDto o : list) {
            if (checkList.contains(o.getOrdersSid())) {
                List<Long> ordersSidList = map.get(o.getOrdersSid().toString());
                if (o.getStatus() == null) {
                    OrdersGoods ordersGoods = ordersGoodsService.findByOdersSidAndGoodsBm(o.getOrdersSid(), o.getGoodsBm());
                    if (!Utils.isNull(ordersGoods)) {
                        ordersSidList.add(ordersGoods.getSid());
                    }
                }
                map.put(o.getOrdersSid().toString(), ordersSidList);
            } else {
                checkList.add(o.getOrdersSid());
                List<Long> ordersSidList = new ArrayList<>();
                if (o.getStatus() == null) {
                    OrdersGoods ordersGoods = ordersGoodsService.findByOdersSidAndGoodsBm(o.getOrdersSid(), o.getGoodsBm());
                    if (!Utils.isNull(ordersGoods)) {
                        ordersSidList.add(ordersGoods.getSid());
                    }
                }
                map.put(o.getOrdersSid().toString(), ordersSidList);

            }
        }
        boolean statusFlag = true;
        for (Map.Entry<String, List<Long>> entry : map.entrySet()) {
            Long[] orderGoodsSids = new Long[entry.getValue().size()];
            Map<String, Object> resultMap = ordersService.sliptOrders(entry.getValue().toArray(orderGoodsSids), Long.parseLong(entry.getKey()), manager);
            boolean flag = (boolean) resultMap.get("flag");
            if (flag) {
                statusFlag = true;
            } else {
                statusFlag = false;
                break;
            }
        }
        if (statusFlag) {
            return true;
        } else {
            return false;
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
