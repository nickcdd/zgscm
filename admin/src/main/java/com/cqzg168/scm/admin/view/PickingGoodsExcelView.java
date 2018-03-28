package com.cqzg168.scm.admin.view;

import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.OrdersGoods;
import com.cqzg168.scm.domain.WithdrawApplyVO;
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
public class PickingGoodsExcelView extends AbstractXlsxView {
    private final static String[] HEADERS = new String[]{"序号", "订单号", "商品sid", "商品名称", "数量", "订单时间"};

    @Override
    protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Orders> ordersList = (List<Orders>) model.get("ordersList");

        Sheet sheet = workbook.createSheet("待拣货列表");

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
                    row.createCell(j++).setCellValue(ordersGoods.getGoods().getSid());
                    row.createCell(j++).setCellValue(ordersGoods.getGoodsCname());


                    row.createCell(j++).setCellValue(ordersGoods.getGoodsCount());


                    row.createCell(j++).setCellValue(DateUtil.dateToString(ordersGoods.getCreateTime(), "yyyy-MM-dd HH:mm:ss"));


                    i++;

                }


            }
        }

        try {
            String fileNmae = URLEncoder.encode("待拣货列表.xlsx", "UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=" + fileNmae);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
