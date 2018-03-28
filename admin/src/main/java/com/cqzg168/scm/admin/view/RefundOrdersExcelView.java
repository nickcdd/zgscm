package com.cqzg168.scm.admin.view;

import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.OrdersGoods;
import com.cqzg168.scm.utils.DateUtil;
import com.cqzg168.scm.utils.Utils;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.web.servlet.view.document.AbstractXlsxView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/6/16 0016.
 */
public class RefundOrdersExcelView extends AbstractXlsxView {
    private final static String[] HEADERS = new String[]{"序号", "订单号", "商品编码", "商品名称", "供应商sid", "供应商名称", "单价（售价）", "数量", "总价", "状态", "订单时间"};

    @Override
    protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Orders> ordersList = (List<Orders>) model.get("ordersList");
        Map<String, Object> countMap = (Map<String, Object>) model.get("countMap");
        boolean typeFlag= (boolean) model.get("typeFlag");
        Sheet sheet=null;
        if(typeFlag) {
             sheet = workbook.createSheet("退款订单统计列表");
        }else{
             sheet = workbook.createSheet("退换货订单统计列表");
        }
        Row header = sheet.createRow(0);
        for (int i = 0; i < HEADERS.length; i++) {
            header.createCell(i).setCellValue(HEADERS[i]);
        }

        int i = 1;
        int m = 1;
        for (Orders orders : ordersList) {
//                Schools school = jdx.getSchools();


            if (!Utils.isEmpty(orders.getOrdersGoodsList())) {
//                Long orderSid=0l;
                boolean flag = true;
                Integer count = 0;
                BigDecimal totalAmount = new BigDecimal("0");
                for (OrdersGoods ordersGoods : orders.getOrdersGoodsList()) {
                    int j = 0;

                    Row row = sheet.createRow(i);
//                row.createCell(j++).setCellValue(m);
                    if (flag) {
                        row.createCell(j++).setCellValue(m);
                        row.createCell(j++).setCellValue(orders.getSid());
                        m++;
                        flag = false;
                    } else {
                        row.createCell(j++).setCellValue("");
                        row.createCell(j++).setCellValue("");
                    }
//                row.createCell(j++).setCellValue(orders.getSid());
                    row.createCell(j++).setCellValue(ordersGoods.getGoodsSpecification().getGoodsBm());
                    row.createCell(j++).setCellValue(ordersGoods.getGoodsCname());
                    row.createCell(j++).setCellValue(orders.getSupplierSid());
                    row.createCell(j++).setCellValue(orders.getSupplierCname());
                    row.createCell(j++).setCellValue(ordersGoods.getGoodsSpecificationPrice().divide(new BigDecimal(ordersGoods.getGoodsSpecification().getSaleCount()), 2, BigDecimal.ROUND_HALF_UP).toString());
                    row.createCell(j++).setCellValue(ordersGoods.getGoodsCount() * ordersGoods.getGoodsSpecification().getSaleCount());
                    row.createCell(j++).setCellValue((ordersGoods.getGoodsSpecificationPrice().multiply(new BigDecimal(ordersGoods.getGoodsCount()))).toString());

                    String status = "";
                    switch (orders.getStatus()) {
                        case 5:
                            status="待退款";
                            break;
                        case 6:
                            status="已退款";
                            break;
                        case 8:
                            status = "申请退货";
                            break;
                        case 9:
                            status = "申请换货";
                            break;
                        case 10:
                            status = "退、换货成功";
                            break;
                    }
                    row.createCell(j++).setCellValue(status);
                    row.createCell(j++).setCellValue(DateUtil.dateToString(ordersGoods.getCreateTime(), "yyyy-MM-dd HH:mm:ss"));
                    count += ordersGoods.getGoodsCount() * ordersGoods.getGoodsSpecification().getSaleCount();
                    totalAmount = totalAmount.add(ordersGoods.getGoodsSpecificationPrice().multiply(new BigDecimal(ordersGoods.getGoodsCount())));
                    i++;

                }

                Row row = sheet.createRow(i);
                CellRangeAddress cra = new CellRangeAddress(i, i, 7, 8);
                sheet.addMergedRegion(cra);
                CellStyle style = workbook.createCellStyle();
                Font font = workbook.createFont();

                font.setColor(Font.COLOR_RED);
                font.setFontHeightInPoints((short) 13);
//                font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
                style.setFont(font);
                Cell cell = row.createCell(7);

                cell.setCellStyle(style);
                cell.setCellValue("小计：" + count + "件,￥" + totalAmount.toString() + "元");
//                cell8.setCellStyle(style);
//                cell8.setCellValue(" ￥"+totalAmount.toString()+ "元");
//                CellRangeAddress cra=new CellRangeAddress(i, i, 7, 8);
//                sheet.addMergedRegion(cra);
                i++;
            }
        }

        try {
            String fileNmae="";
            if(typeFlag) {
                 fileNmae = URLEncoder.encode("退款订单统计列表.xlsx", "UTF-8");
            }else{
                 fileNmae = URLEncoder.encode("退换货订单统计列表.xlsx", "UTF-8");
            }
            response.setHeader("Content-Disposition", "attachment; filename=" + fileNmae);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
