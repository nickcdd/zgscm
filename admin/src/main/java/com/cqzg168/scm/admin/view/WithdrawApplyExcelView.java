package com.cqzg168.scm.admin.view;

import com.cqzg168.scm.domain.Manager;
import com.cqzg168.scm.domain.WithdrawApply;
import com.cqzg168.scm.domain.WithdrawApplyVO;
import com.cqzg168.scm.repository.ManagerRepository;
import com.cqzg168.scm.service.ManagerService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.DateUtil;
import com.cqzg168.scm.utils.Utils;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.servlet.view.document.AbstractXlsxView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/5/17 0017.
 */

public class WithdrawApplyExcelView extends AbstractXlsxView {
    private final static String[] HEADERS = new String[]{"序号", "商户sid", "商户名称", "银行名称", "银行卡号", "提现金额", "审核状态", "审核原因", "审核人", "创建时间"};


    @Override
    protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<WithdrawApplyVO> withdrawApplyList = (List<WithdrawApplyVO>) model.get("withdrawApplyList");

        Sheet sheet = workbook.createSheet("提现申请列表");

        Row header = sheet.createRow(0);
        for (int i = 0; i < HEADERS.length; i++) {
            header.createCell(i).setCellValue(HEADERS[i]);
        }

        int i = 1;
        for (WithdrawApplyVO withdrawApplyVO : withdrawApplyList) {
//                Schools school = jdx.getSchools();

            int j = 0;
            Row row = sheet.createRow(i);

            row.createCell(j++).setCellValue(i);
            row.createCell(j++).setCellValue(withdrawApplyVO.getShopKeeperSid());
            row.createCell(j++).setCellValue(withdrawApplyVO.getShopKeeperCname());
            row.createCell(j++).setCellValue(withdrawApplyVO.getBankName());
            row.createCell(j++).setCellValue(withdrawApplyVO.getCardNo());
            row.createCell(j++).setCellValue(withdrawApplyVO.getAmount().toString());


            String status = "";
            switch (withdrawApplyVO.getStatus()) {
                case -1:
                    status = "删除";
                    break;
                case 0:
                    status = "拒绝";
                    break;
                case 1:
                    status = "待审核";
                    break;
                case 2:
                    status = "通过";
                    break;
            }
            row.createCell(j++).setCellValue(status);
            row.createCell(j++).setCellValue(withdrawApplyVO.getReason());
//            if (!Utils.isNull(withdrawApply.getManagerSid())) {
//                System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>+++++"+withdrawApply.getManagerSid());
////                Manager manager = managerService.findOne(Long.parseLong("9"));
////                System.out.println(repository.findAll().size());
////                row.createCell(j++).setCellValue(manager.getUsername());
//            } else {
//                row.createCell(j++).setCellValue("无");
//            }
            row.createCell(j++).setCellValue(withdrawApplyVO.getManagerName());


            row.createCell(j++).setCellValue(DateUtil.dateToString(withdrawApplyVO.getCreateTime(), "yyyy-MM-dd HH:mm:ss"));
            i++;
        }

        try {
            String fileNmae = URLEncoder.encode("提现申请列表.xlsx", "UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=" + fileNmae);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
