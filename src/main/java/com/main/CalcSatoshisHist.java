package com.main;

import com.jsonmodel.PriceChart;
import com.model.CoinPerUser;
import com.model.Quotation;

public class CalcSatoshisHist {

	public PriceChart calc(CoinPerUser coinPerUser, Quotation record, Double btcPrice) {

		// CALCULO
		// TOTAL (UNIDADES MONEDA * (SATOSHIS ACTUALES RESULTADO API) * PRECIO BTC) -
		// INVERTIDO

		PriceChart resultToChart = new PriceChart();
		Double price = (coinPerUser.getQuantity().doubleValue() * record.getSatoshis().doubleValue() * 
				(record.getCoinByExchange().getCoinPair().getIsFinal() ? 1D : btcPrice))
				- coinPerUser.getInvested().doubleValue();

		resultToChart.setPrice(price);
		resultToChart.setTime(record.getTimestamp().getTime());
		resultToChart.setIdCrypto(coinPerUser.getCoinByExchange().getCoin().getId());
		return resultToChart;
	}
}
