package com.cqzg168.scm.supplier.view;

import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.utils.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.web.servlet.view.document.AbstractXlsxView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/5/27 0017.
 */

public class OrdersExcelView extends AbstractXlsxView {
    private final static String[] HEADERS = new String[]{"序号", "创建时间", "订单编号", "商户名称", "联系电话", "收货地址", "订单金额", "订单状态", "支付方式"};


    @Override
    protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Orders> ordersList = (List<Orders>) model.get("OrdersList");

        Sheet sheet = workbook.createSheet("订单列表");

        Row header = sheet.createRow(0);
        for (int i = 0; i < HEADERS.length; i++) {
            header.createCell(i).setCellValue(HEADERS[i]);
        }

        int i = 1;
        for (Orders orders : ordersList) {
            int j = 0;
            Row row = sheet.createRow(i);

            row.createCell(j++).setCellValue(i);
            row.createCell(j++).setCellValue(DateUtil.dateToString(orders.getCreateTime(), "yyyy-MM-dd HH:mm:ss"));
            row.createCell(j++).setCellValue(orders.getSid());
            row.createCell(j++).setCellValue(orders.getShopKeeper().getCname());
            row.createCell(j++).setCellValue(orders.getShopKeeper().getTelephone());
            row.createCell(j++).setCellValue(orders.getAddress());
            row.createCell(j++).setCellValue(orders.getPayAmount().toString());
            String status = "";
            switch (orders.getStatus()){
                case 2:
                    status = "待发货";
                    break;
                case 3:
                    status = "已发货";
                    break;
                case 4:
                    status = "已收货";
                    break;
                default:
                    status = "状态错误";
                    break;
            }
            row.createCell(j++).setCellValue(status);
            String payType = "";
            switch (orders.getChannel()) {
                case 1:
                    payType = "微信支付";
                    break;
                case 2:
                    payType = "支付宝支付";
                    break;
                case 3:
                    payType = "银联支付";
                    break;
                default:
                    payType = "其它支付";
                    break;
            }
            row.createCell(j++).setCellValue(payType);

            i++;
        }
        try {
            String fileNmae = URLEncoder.encode("商户订单数据.xlsx", "UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=" + fileNmae);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}